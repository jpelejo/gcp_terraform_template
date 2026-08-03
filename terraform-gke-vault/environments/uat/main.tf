# -----------------------------------------------------------------------------
# Environment: UAT
# TOGAF Migration Planning / Implementation Governance: business
# stakeholder sign-off environment. Configured close to production
# posture (dedicated Vault node pool, Binary Authorization, deletion
# protection, restricted control-plane access, full audit logging).
# -----------------------------------------------------------------------------

module "network" {
  source = "../../modules/network"

  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  network_name     = var.network_name
  subnet_cidr      = var.subnet_cidr
  pods_cidr        = var.pods_cidr
  services_cidr    = var.services_cidr
  enable_flow_logs = true
  labels           = var.labels
}

module "nat" {
  source = "../../modules/nat"

  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  name_prefix      = var.network_name
  network_id       = module.network.network_id
  enable_logging   = true
  min_ports_per_vm = 128
}

module "iam" {
  source = "../../modules/iam"

  project_id  = var.project_id
  environment = var.environment
}

module "gke" {
  source = "../../modules/gke"

  project_id                  = var.project_id
  region                      = var.region
  environment                 = var.environment
  cluster_name                = "gke-vault-${var.environment}"
  network_id                  = module.network.network_id
  subnet_id                   = module.network.subnet_id
  pods_range_name              = module.network.pods_range_name
  services_range_name          = module.network.services_range_name
  node_service_account_email  = module.iam.gke_node_sa_email
  release_channel             = "REGULAR"
  enable_private_nodes        = true
  enable_private_endpoint     = false
  master_ipv4_cidr_block      = var.master_ipv4_cidr_block
  master_authorized_networks  = var.master_authorized_networks
  node_pools                  = var.node_pools
  enable_binary_authorization = true
  enable_deletion_protection  = true
  labels                      = var.labels

  depends_on = [module.nat]
}

module "vault" {
  source = "../../modules/vault"

  project_id           = var.project_id
  region               = var.region
  environment          = var.environment
  vault_sa_email       = module.iam.vault_sa_email
  storage_bucket_name  = var.vault_storage_bucket_name
  kms_key_ring_name    = var.kms_key_ring_name
  kms_key_name         = var.kms_key_name
  ha_replicas          = var.vault_ha_replicas
  audit_enabled        = true

  depends_on = [module.gke]
}
