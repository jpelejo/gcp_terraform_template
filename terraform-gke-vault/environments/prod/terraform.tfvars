project_id  = "my-gcp-project-prod"
region      = "us-east1"
environment = "prod"

vault_storage_bucket_name = "my-gcp-project-prod-vault-storage" # must be globally unique
kms_key_ring_name         = "vault-keyring-prod"
kms_key_name              = "vault-unseal-key-prod"
vault_ha_replicas         = 5
