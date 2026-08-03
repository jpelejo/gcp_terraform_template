project_id  = "my-gcp-project-uat"
region      = "us-east1"
environment = "uat"

vault_storage_bucket_name = "my-gcp-project-uat-vault-storage" # must be globally unique
kms_key_ring_name         = "vault-keyring-uat"
kms_key_name              = "vault-unseal-key-uat"
vault_ha_replicas         = 3
