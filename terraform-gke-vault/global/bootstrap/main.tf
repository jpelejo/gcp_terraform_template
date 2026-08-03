# -----------------------------------------------------------------------------
# Bootstrap: Terraform Remote State
# TOGAF Preliminary Phase: establishes the foundational architecture capability
# (governed, versioned state) required before any environment can be built.
# Run this FIRST, with LOCAL state, once per GCP project/org. Its own state
# is intentionally not stored in the bucket it creates (chicken-and-egg).
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
  description = "GCP project ID that will host the shared Terraform state bucket"
  type        = string
}

variable "region" {
  description = "GCP region for the state bucket"
  type        = string
  default     = "us-east1"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the Terraform state bucket"
  type        = string
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tf_state" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 604800 # 7 days
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "state_bucket_name" {
  value = google_storage_bucket.tf_state.name
}
