# -----------------------------------------------------------------------------
# Network Module
# TOGAF Technology Architecture domain: defines the base connectivity building
# block shared by every environment - VPC, subnet, secondary ranges, and
# baseline firewalling. Kept intentionally generic so the same artifact can
# be promoted dev -> qa -> uat -> preprod -> prod unchanged, only the calling
# environment's variables differ. Egress (Cloud NAT) is a separate concern -
# see modules/nat.
# -----------------------------------------------------------------------------

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                     = var.network_name
  auto_create_subnetworks  = false
  routing_mode             = "REGIONAL"
}

resource "google_compute_subnetwork" "gke_subnet" {
  project                  = var.project_id
  name                     = "${var.network_name}-${var.environment}-subnet"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = var.enable_private_google_access

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

# NOTE: Cloud NAT (egress for private nodes) now lives in modules/nat,
# so it can be reasoned about and scaled independently of VPC/subnet design.
# See environments/<env>/main.tf for how the two modules are wired together.

# Baseline firewall: allow internal traffic within the VPC only.
resource "google_compute_firewall" "allow_internal" {
  project = var.project_id
  name    = "${var.network_name}-${var.environment}-allow-internal"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.pods_cidr, var.services_cidr]
}
