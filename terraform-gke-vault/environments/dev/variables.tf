variable "project_id" {
  description = "GCP project ID for the dev environment"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "network_name" {
  type    = string
  default = "gke-vault"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/20"
}

variable "pods_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "services_cidr" {
  type    = string
  default = "10.200.0.0/20"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    { cidr_block = "0.0.0.0/0", display_name = "open-for-dev-only" }
  ]
}

variable "node_pools" {
  type = map(object({
    machine_type  = string
    disk_size_gb  = number
    disk_type     = string
    min_count     = number
    max_count     = number
    initial_count = number
    preemptible   = bool
    labels        = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {
    general = {
      machine_type  = "e2-standard-2"
      disk_size_gb  = 50
      disk_type     = "pd-standard"
      min_count     = 1
      max_count     = 2
      initial_count = 1
      preemptible   = true
      labels        = { workload = "general" }
      taints        = []
    }
  }
}

variable "vault_storage_bucket_name" {
  type    = string
  default = "" # set in terraform.tfvars - must be globally unique
}

variable "kms_key_ring_name" {
  type    = string
  default = "vault-keyring-dev"
}

variable "kms_key_name" {
  type    = string
  default = "vault-unseal-key-dev"
}

variable "vault_ha_replicas" {
  type    = number
  default = 1
}

variable "labels" {
  type = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    owner       = "platform-engineering"
  }
}
