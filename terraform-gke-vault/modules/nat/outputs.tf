output "router_name" {
  value = google_compute_router.router.name
}

output "router_id" {
  value = google_compute_router.router.id
}

output "nat_name" {
  value = google_compute_router_nat.nat.name
}
