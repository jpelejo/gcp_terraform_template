terraform {
  backend "gcs" {
    bucket = "REPLACE_WITH_TFSTATE_BUCKET" # created by global/bootstrap
    prefix = "gke-vault/dev"
  }
}
