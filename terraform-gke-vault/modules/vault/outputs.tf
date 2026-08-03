output "namespace" {
  value = kubernetes_namespace.vault.metadata[0].name
}

output "helm_release_name" {
  value = helm_release.vault.name
}

output "kms_key_id" {
  value = google_kms_crypto_key.vault_unseal.id
}

output "storage_bucket" {
  value = google_storage_bucket.vault_storage.name
}
