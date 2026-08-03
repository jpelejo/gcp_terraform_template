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
  ```text
terraform-gke-vault/
├── .gitignore
├── README.md
├── main.tf                     # Root placeholder (environments are separate workspaces)
├── providers.tf                # Provider configurations (google, helm, kubernetes, vault)
├── versions.tf                 # Terraform and provider version constraints
├── modules/                    # Reusable, versioned modules
│   ├── gke/                    # GKE cluster module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vault/                  # Vault (Helm) module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/               # Environment-specific configurations
│   ├── dev/
│   │   ├── main.tf             # Calls gke and vault modules
│   │   ├── variables.tf        # Variable declarations
│   │   ├── terraform.tfvars    # Example values (replace with your actual values)
│   │   ├── providers.tf        # Provider configs (copied from root)
│   │   └── versions.tf         # Version constraints (copied from root)
│   ├── qa/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── providers.tf
│   │   └── versions.tf
│   ├── uat/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── providers.tf
│   │   └── versions.tf
│   ├── pre-prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── providers.tf
│   │   └── versions.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── providers.tf
│       └── versions.tf
  ```
</details>
