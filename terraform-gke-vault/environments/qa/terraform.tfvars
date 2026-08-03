project_id  = "my-gcp-project-qa"
region      = "us-east1"
environment = "qa"

vault_storage_bucket_name = "my-gcp-project-qa-vault-storage" # must be globally unique
kms_key_ring_name         = "vault-keyring-qa"
kms_key_name              = "vault-unseal-key-qa"
vault_ha_replicas         = 3
