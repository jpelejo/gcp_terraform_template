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
  default     = "prod"
}

variable "network_name" {
  type    = string
  default = "gke-vault"
}

variable "subnet_cidr" {
  type    = string
  default = "10.14.0.0/20"
}

variable "pods_cidr" {
  type    = string
  default = "10.104.0.0/16"
}

variable "services_cidr" {
  type    = string
  default = "10.204.0.0/20"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.4.0/28"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    { cidr_block = "10.0.0.0/8", display_name = "corp-vpn-range" }
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
      machine_type  = "e2-standard-4"
      disk_size_gb  = 200
      disk_type     = "pd-ssd"
      min_count     = 3
      max_count     = 10
      initial_count = 3
      preemptible   = false
      labels        = { workload = "general" }
      taints        = []
    }
    vault = {
      machine_type  = "e2-standard-4"
      disk_size_gb  = 200
      disk_type     = "pd-ssd"
      min_count     = 3
      max_count     = 5
      initial_count = 3
      preemptible   = false
      labels        = { workload = "vault" }
      taints = [
        { key = "dedicated", value = "vault", effect = "NO_SCHEDULE" }
      ]
    }
  }
}

variable "vault_storage_bucket_name" {
  type    = string
  default = "" # set in terraform.tfvars - must be globally unique
}

variable "kms_key_ring_name" {
  type    = string
  default = "vault-keyring-prod"
}

variable "kms_key_name" {
  type    = string
  default = "vault-unseal-key-prod"
}

variable "vault_ha_replicas" {
  type    = number
  default = 5
}

variable "labels" {
  type = map(string)
  default = {
    environment = "prod"
    managed_by  = "terraform"
    owner       = "platform-engineering"
  }
}
