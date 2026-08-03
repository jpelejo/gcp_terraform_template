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

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary CIDR range for the GKE node subnet"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary CIDR range for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary CIDR range for GKE services"
  type        = string
}

variable "enable_private_google_access" {
  description = "Enable Private Google Access on the subnet"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logs (recommended true for uat/preprod/prod)"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Common resource labels"
  type        = map(string)
  default     = {}
}
