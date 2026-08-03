project_id  = "my-gcp-project-dev"
region      = "us-east1"
environment = "dev"

vault_storage_bucket_name = "my-gcp-project-dev-vault-storage" # must be globally unique
kms_key_ring_name         = "vault-keyring-dev"
kms_key_name              = "vault-unseal-key-dev"
vault_ha_replicas         = 1
