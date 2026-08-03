variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, uat, preprod, prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name the Cloud Router and NAT gateway, typically the network name"
  type        = string
}

variable "network_id" {
  description = "Self-link/id of the VPC network the router attaches to"
  type        = string
}

variable "subnetworks" {
  description = <<-EOT
    Optional explicit list of subnets for NAT to cover, each with the ranges
    to NAT. Leave empty to NAT all IP ranges of all subnets in the region
    (the common case for a single-subnet-per-environment network).
  EOT
  type = list(object({
    subnetwork_id           = string
    source_ip_ranges_to_nat = list(string) # e.g. ["ALL_IP_RANGES"] or specific range names
  }))
  default = []
}

variable "nat_ip_allocate_option" {
  description = "AUTO_ONLY (Google-managed NAT IPs) or MANUAL_ONLY (bring your own reserved IPs)"
  type        = string
  default     = "AUTO_ONLY"
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated per VM. Raise for high-connection workloads (e.g. prod)."
  type        = number
  default     = 64
}

variable "enable_logging" {
  description = "Enable Cloud NAT logging (recommended true for uat/preprod/prod)"
  type        = bool
  default     = false
}

variable "log_filter" {
  description = "Which NAT events to log: ERRORS_ONLY, TRANSLATIONS_ONLY, or ALL"
  type        = string
  default     = "ERRORS_ONLY"
}
