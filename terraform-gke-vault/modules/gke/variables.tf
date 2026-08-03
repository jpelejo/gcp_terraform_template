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

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "network_id" {
  description = "VPC self_link/id to attach the cluster to"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id for the cluster nodes"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary range name for pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary range name for services"
  type        = string
}

variable "node_service_account_email" {
  description = "Service account email used by node pools"
  type        = string
}

variable "release_channel" {
  description = "GKE release channel (RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "enable_private_nodes" {
  description = "Run nodes without public IPs"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Make the control plane endpoint private (no public access at all). Recommended true for prod/preprod."
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR for the GKE master's private endpoint"
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  description = "CIDR blocks allowed to reach the control plane public endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "node_pools" {
  description = "Map of node pool configurations"
  type = map(object({
    machine_type   = string
    disk_size_gb   = number
    disk_type      = string
    min_count      = number
    max_count      = number
    initial_count  = number
    preemptible    = bool
    labels         = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
}

variable "maintenance_start_time" {
  description = "RFC3339 start time for the daily maintenance window"
  type        = string
  default     = "03:00"
}

variable "enable_binary_authorization" {
  description = "Enforce Binary Authorization (recommended true for prod)"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Prevent accidental cluster deletion (recommended true for uat/preprod/prod)"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Common resource labels"
  type        = map(string)
  default     = {}
}
