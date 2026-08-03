# -----------------------------------------------------------------------------
# Global Org/Project Policies
# TOGAF Architecture Governance: guardrails that apply across every
# environment regardless of which team or pipeline runs the environment
# stacks. Kept separate so security/platform teams can own and review this
# independently of application/environment changes.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}

variable "project_id" {
  type = string
}

provider "google" {
  project = var.project_id
}

# Require OS Login instead of per-instance SSH keys.
resource "google_project_organization_policy" "os_login" {
  project    = var.project_id
  constraint = "compute.requireOsLogin"

  boolean_policy {
    enforced = true
  }
}

# Disable service account key creation - forces Workload Identity usage,
# consistent with modules/iam.
resource "google_project_organization_policy" "disable_sa_key_creation" {
  project    = var.project_id
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}

# Restrict public IPs on GKE nodes at the org-policy layer as defense in
# depth on top of the module-level enable_private_nodes setting.
resource "google_project_organization_policy" "restrict_public_ip" {
  project    = var.project_id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}
