output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}

output "vault_namespace" {
  value = module.vault.namespace
}

output "vault_kms_key_id" {
  value = module.vault.kms_key_id
}

output "network_name" {
  value = module.network.network_name
}

output "nat_router_name" {
  value = module.nat.router_name
}

output "nat_gateway_name" {
  value = module.nat.nat_name
}
