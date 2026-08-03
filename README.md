<h1> Google Cloud Platform Terraform Multi Environment Template </h1>


The purpose of creating the repository is to give an example of how to create a multi environment template with vault capabilities.  

Best practice is to have the Terraform files
1.  No hard coded values
2.  Save in an encrypted storage area with limited access
3.  Enable the versioning for the storage area
4.  Use the vault and Secrets Manager to hide credentials that may be used for datasources, APIs, etc.

Using a parent / child folder structure helps structure the files in a way where if there are common attributes such as provider information, it is not repeated in the child folders and derived from the parent folders.  

Here is how the files and folders are structured and created:

<details>
  <summary>Click to expand project structure</summary>

```text
terraform-gke-vault/
├── global/                      # Run once per org/project, before environments
│   ├── bootstrap/               # Creates the GCS remote-state bucket
│   └── org-policies/            # Org/project-level security guardrails
│
├── modules/                     # Parent building blocks (reusable, versioned, environment-agnostic)
│   ├── network/                 # VPC, subnet, secondary ranges, Cloud NAT
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

</details>



