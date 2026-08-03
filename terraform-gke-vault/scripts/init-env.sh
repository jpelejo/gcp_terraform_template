#!/usr/bin/env bash
# Convenience wrapper: ./scripts/init-env.sh <env> <init|plan|apply|destroy>
# <env> must be one of: dev qa uat preprod prod
set -euo pipefail

ENV="${1:-}"
ACTION="${2:-plan}"
VALID_ENVS=(dev qa uat preprod prod)

if [[ -z "$ENV" ]] || [[ ! " ${VALID_ENVS[*]} " =~ " ${ENV} " ]]; then
  echo "Usage: $0 <${VALID_ENVS[*]// /|}> <init|plan|apply|destroy>"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${REPO_ROOT}/environments/${ENV}"

if [[ ! -d "$ENV_DIR" ]]; then
  echo "Environment directory not found: $ENV_DIR"
  exit 1
fi

cd "$ENV_DIR"

case "$ACTION" in
  init)
    terraform init
    ;;
  plan)
    terraform init -upgrade=false
    terraform plan -var-file=terraform.tfvars
    ;;
  apply)
    terraform init -upgrade=false
    terraform apply -var-file=terraform.tfvars
    ;;
  destroy)
    echo "About to DESTROY environment: ${ENV}. Ctrl+C within 5s to cancel."
    sleep 5
    terraform init -upgrade=false
    terraform destroy -var-file=terraform.tfvars
    ;;
  *)
    echo "Unknown action: $ACTION (expected init|plan|apply|destroy)"
    exit 1
    ;;
esac
