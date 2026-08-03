variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for Vault"
  type        = string
  default     = "vault"
}

variable "vault_sa_email" {
  description = "GCP service account email bound via Workload Identity"
  type        = string
}

variable "helm_chart_version" {
  description = "Version of the hashicorp/vault Helm chart"
  type        = string
  default     = "0.28.1"
}

variable "ha_replicas" {
  description = "Number of Vault replicas in HA (Raft) mode"
  type        = number
  default     = 3
}

variable "storage_bucket_name" {
  description = "GCS bucket used for Vault snapshot/backup storage"
  type        = string
}

variable "kms_key_ring_name" {
  description = "Name of the Cloud KMS key ring used for Vault auto-unseal"
  type        = string
}

variable "kms_key_name" {
  description = "Name of the Cloud KMS crypto key used for Vault auto-unseal"
  type        = string
}

variable "resources" {
  description = "CPU/memory requests and limits for each Vault pod"
  type = object({
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
  })
  default = {
    requests_cpu    = "250m"
    requests_memory = "256Mi"
    limits_cpu      = "1"
    limits_memory   = "1Gi"
  }
}

variable "storage_size" {
  description = "Persistent volume size per Vault pod"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "Kubernetes storage class for Vault's Raft data volume"
  type        = string
  default     = "standard-rwo"
}

variable "audit_enabled" {
  description = "Whether to enable Vault file audit device (recommended true for uat/preprod/prod)"
  type        = bool
  default     = false
}

variable "ui_enabled" {
  description = "Enable the Vault web UI"
  type        = bool
  default     = true
}
