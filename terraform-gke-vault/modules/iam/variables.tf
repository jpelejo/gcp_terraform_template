variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "gke_node_roles" {
  description = "IAM roles bound to the GKE node service account"
  type        = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
  ]
}

variable "vault_roles" {
  description = "IAM roles bound to the Vault workload-identity service account"
  type        = list(string)
  default = [
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/storage.objectAdmin",
  ]
}

variable "vault_k8s_namespace" {
  description = "Kubernetes namespace Vault runs in"
  type        = string
  default     = "vault"
}

variable "vault_k8s_service_account" {
  description = "Kubernetes service account name used by Vault"
  type        = string
  default     = "vault"
}
