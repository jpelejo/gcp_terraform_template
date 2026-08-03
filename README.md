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

terraform-gke-vault
├── docs
│   ├── architecture-decision-records
│   │   └── ADR-001-gke-vault-architecture.md
│   └── TOGAF-alignment.md
├── environments
│   ├── dev
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── preprod
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── qa
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── uat
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── global
│   ├── bootstrap
│   │   └── main.tf
│   └── org-policies
│       └── main.tf
├── modules
│   ├── gke
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── nat
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── vault
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── versions.tf
├── README.md
└── scripts
    └── init-env.sh


```

</details>



