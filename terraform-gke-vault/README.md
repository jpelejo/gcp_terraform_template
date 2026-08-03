# GKE + Vault — Terraform Landing Zone

Terraform for provisioning **Google Kubernetes Engine (GKE)** clusters with
**HashiCorp Vault** across five environments — `dev`, `qa`, `uat`, `preprod`,
`prod` — using a parent/child (shared-modules + environment-overlays)
structure aligned to **TOGAF ADM** governance practices.

## Repository layout

```
terraform-gke-vault/
├── global/                      # Run once per org/project, before environments
│   ├── bootstrap/               # Creates the GCS remote-state bucket
│   └── org-policies/            # Org/project-level security guardrails
│
├── modules/                     # Parent building blocks (reusable, versioned, environment-agnostic)
│   ├── network/                 # VPC, subnet, secondary ranges, baseline firewall
│   ├── nat/                     # Cloud Router + Cloud NAT (egress for private nodes)
│   ├── iam/                     # Service accounts + Workload Identity bindings
│   ├── gke/                     # GKE cluster + node pools
│   └── vault/                   # Vault Helm release, KMS auto-unseal, GCS storage
│
├── environments/                # Child overlays — one per environment
│   ├── dev/
│   ├── qa/
│   ├── uat/
│   ├── preprod/
│   └── prod/
│       ├── backend.tf           # Remote state config (unique prefix per env)
│       ├── provider.tf          # Provider + version pins
│       ├── variables.tf         # Environment-specific variable declarations
│       ├── terraform.tfvars     # Environment-specific values (edit before apply)
│       ├── main.tf              # Wires modules together
│       └── outputs.tf
│
├── docs/
│   ├── TOGAF-alignment.md
│   └── architecture-decision-records/
│       └── ADR-001-gke-vault-architecture.md
│
└── scripts/
    └── init-env.sh              # Convenience wrapper for terraform init/plan/apply per env
```

## Why this shape (parent/child pattern)

- **Parent modules** (`modules/*`) encode the *architecture standard* — how a
  GKE cluster and Vault are built, secured, and wired together. They contain
  no environment-specific values, so the same reviewed, versioned artifact is
  promoted unchanged from `dev` through `prod`.
- **Child overlays** (`environments/*`) encode *architecture instantiation* —
  sizing, scaling, and risk posture per environment (see the table below).
  Only these files change as you promote a change up the chain.
- **`global/`** encodes *governance preconditions* — remote state and
  org policies that must exist before any environment stack can run, owned by
  a platform/security team rather than application teams.

This separation is what TOGAF calls distinguishing reusable **Architecture
Building Blocks** (the modules) from environment-specific **Solution Building
Blocks** (the overlays) — see `docs/TOGAF-alignment.md` for the full mapping.

## Environment posture summary

| Environment | Node pools | Vault replicas | Release channel | Private endpoint | Deletion protection | Binary Auth | Audit log | NAT logging | NAT min ports/VM |
|---|---|---|---|---|---|---|---|---|---|
| dev | 1 (preemptible) | 1 | RAPID | No | No | No | No | No | 64 |
| qa | 1 (on-demand) | 3 | REGULAR | No | No | No | Yes | Yes | 64 |
| uat | general + dedicated vault pool | 3 | REGULAR | No (VPN-restricted) | Yes | Yes | Yes | Yes | 128 |
| preprod | general + dedicated vault pool | 3 | STABLE | Yes | Yes | Yes | Yes | Yes | 128 |
| prod | general + dedicated vault pool (autoscaled) | 5 | STABLE | Yes | Yes | Yes | Yes | Yes | 256 |

## Usage

### 1. One-time setup (per GCP project/org)

```bash
cd global/bootstrap
terraform init
terraform apply -var="project_id=<PROJECT_ID>" -var="state_bucket_name=<UNIQUE_BUCKET_NAME>"

cd ../org-policies
terraform init
terraform apply -var="project_id=<PROJECT_ID>"
```

### 2. Per environment

```bash
cd environments/dev
# Update backend.tf with the bucket created above, and edit terraform.tfvars
terraform init
terraform plan  -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Or use the helper script:

```bash
./scripts/init-env.sh dev plan
./scripts/init-env.sh dev apply
```

Repeat per environment, promoting a reviewed module change through
`dev → qa → uat → preprod → prod` via your normal PR/CI process.

## Prerequisites

- Terraform >= 1.6.0
- A GCP project per environment (recommended) with the following APIs
  enabled: Compute Engine, GKE, Cloud KMS, Cloud Storage, IAM, Cloud
  Resource Manager.
- `gcloud` authenticated with permissions to create the above resources.
- Helm/Kubernetes providers authenticate directly against the cluster this
  same stack creates — no separate kubeconfig step is required.

## Security notes

- Vault is deployed in HA/Raft mode, auto-unsealed via Cloud KMS — no
  unseal keys are ever handled manually or stored in state.
- GKE nodes run without public IPs (`enable_private_nodes = true`) with
  Cloud NAT for egress.
- Workload Identity is used everywhere; no service account JSON keys are
  generated or distributed (also enforced by `global/org-policies`).
- `terraform.tfvars` files in this repo use **placeholder** project IDs and
  bucket names — replace them with real values via your secrets/CI variable
  system before applying. Do not commit real project IDs or bucket names if
  your organization treats them as sensitive.
