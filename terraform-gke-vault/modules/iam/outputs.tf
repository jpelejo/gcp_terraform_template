output "gke_node_sa_email" {
  value = google_service_account.gke_node_sa.email
}

output "vault_sa_email" {
  value = google_service_account.vault_sa.email
}
