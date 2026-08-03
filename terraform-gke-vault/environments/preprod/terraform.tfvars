project_id  = "my-gcp-project-preprod"
region      = "us-east1"
environment = "preprod"

vault_storage_bucket_name = "my-gcp-project-preprod-vault-storage" # must be globally unique
kms_key_ring_name         = "vault-keyring-preprod"
kms_key_name              = "vault-unseal-key-preprod"
vault_ha_replicas         = 3
