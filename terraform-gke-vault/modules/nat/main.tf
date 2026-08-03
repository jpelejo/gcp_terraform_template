# -----------------------------------------------------------------------------
# NAT Module
# TOGAF Technology Architecture domain: egress connectivity building block,
# kept separate from modules/network so it can be reasoned about, reviewed,
# and (if ever needed) swapped or scaled independently of VPC/subnet design -
# e.g. bumping min_ports_per_vm or switching to reserved NAT IPs for prod
# without touching addressing or firewall rules.
# -----------------------------------------------------------------------------

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.name_prefix}-${var.environment}-router"
  region  = var.region
  network = var.network_id
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "${var.name_prefix}-${var.environment}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = length(var.subnetworks) > 0 ? "LIST_OF_SUBNETWORKS" : "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                   = var.min_ports_per_vm

  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                    = subnetwork.value.subnetwork_id
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }

  log_config {
    enable = var.enable_logging
    filter = var.log_filter
  }
}
