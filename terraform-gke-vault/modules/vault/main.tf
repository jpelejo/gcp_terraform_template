# -----------------------------------------------------------------------------
# Vault Module
# TOGAF Security Architecture domain: secrets-management platform building
# block. Deploys HashiCorp Vault via the official Helm chart in HA/Raft mode,
# auto-unsealed with Cloud KMS, backed by a dedicated GCS bucket for snapshots.
# -----------------------------------------------------------------------------

resource "google_kms_key_ring" "vault" {
  project  = var.project_id
  name     = var.kms_key_ring_name
  location = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "vault_unseal" {
  name            = var.kms_key_name
  key_ring        = google_kms_key_ring.vault.id
  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket" "vault_storage" {
  project                     = var.project_id
  name                        = var.storage_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "environment"                  = var.environment
    }
  }
}

resource "kubernetes_service_account" "vault" {
  metadata {
    name      = "vault"
    namespace = kubernetes_namespace.vault.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = var.vault_sa_email
    }
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.helm_chart_version
  namespace  = kubernetes_namespace.vault.metadata[0].name

  values = [
    yamlencode({
      server = {
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.vault.metadata[0].name
        }
        ha = {
          enabled  = true
          replicas = var.ha_replicas
          raft = {
            enabled = true
          }
        }
        dataStorage = {
          enabled      = true
          size         = var.storage_size
          storageClass = var.storage_class
        }
        resources = {
          requests = {
            cpu    = var.resources.requests_cpu
            memory = var.resources.requests_memory
          }
          limits = {
            cpu    = var.resources.limits_cpu
            memory = var.resources.limits_memory
          }
        }
        auditStorage = {
          enabled = var.audit_enabled
          size    = "10Gi"
        }
        extraEnvironmentVars = {
          GOOGLE_REGION  = var.region
          GOOGLE_PROJECT = var.project_id
        }
        # Cloud KMS auto-unseal + Raft integrated storage.
        extraArgs = ""
        standalone = {
          enabled = false
        }
      }
      ui = {
        enabled     = var.ui_enabled
        serviceType = "ClusterIP"
      }
      injector = {
        enabled = true
      }
    })
  ]

  set {
    name  = "server.ha.raft.config"
    value = <<-HCL
      ui = ${var.ui_enabled}
      listener "tcp" {
        address     = "[::]:8200"
        cluster_address = "[::]:8201"
        tls_disable = 1
      }
      storage "raft" {
        path = "/vault/data"
      }
      seal "gcpckms" {
        project    = "${var.project_id}"
        region     = "${var.region}"
        key_ring   = "${google_kms_key_ring.vault.name}"
        crypto_key = "${google_kms_crypto_key.vault_unseal.name}"
      }
    HCL
  }

  depends_on = [kubernetes_service_account.vault]
}
