# -----------------------------------------------------------------------------
# IAM Module
# TOGAF Security Architecture (cross-cutting): least-privilege service
# accounts for GKE nodes and for Vault, wired to GCP Workload Identity so no
# static keys are ever distributed to pods.
# -----------------------------------------------------------------------------

resource "google_service_account" "gke_node_sa" {
  project      = var.project_id
  account_id   = "gke-node-${var.environment}"
  display_name = "GKE Node SA - ${var.environment}"
}

resource "google_project_iam_member" "gke_node_roles" {
  for_each = toset(var.gke_node_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gke_node_sa.email}"
}

resource "google_service_account" "vault_sa" {
  project      = var.project_id
  account_id   = "vault-${var.environment}"
  display_name = "Vault Workload Identity SA - ${var.environment}"
}

resource "google_project_iam_member" "vault_roles" {
  for_each = toset(var.vault_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.vault_sa.email}"
}

# Bind the GCP SA to the Kubernetes SA via Workload Identity so Vault pods
# can auto-unseal against Cloud KMS and use GCS as storage backend without
# mounting a JSON key.
resource "google_service_account_iam_member" "vault_workload_identity" {
  service_account_id = google_service_account.vault_sa.name
  role                = "roles/iam.workloadIdentityUser"
  member              = "serviceAccount:${var.project_id}.svc.id.goog[${var.vault_k8s_namespace}/${var.vault_k8s_service_account}]"
}
