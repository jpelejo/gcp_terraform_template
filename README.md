<h1> Google Cloud Platform Terraform Multi Environment Template </h1>


The purpose of creating the repository is to give an example of how to create a multi environment template with vault capabilities.  

Best practice is to have the Terraform files
1.  No hard coded values
2.  Save in an encrypted storage area with limited access
3.  Enable the versioning for the storage area
4.  Use the vault and Secrets Manager to hide credentials that may be used for datasources, APIs, etc.

Using a parent / child folder structure helps structure the files in a way where if there are common attributes such as provider information, it is not repeated in the child folders and derived from the parent folders.  Also following the TOGAF principles makes sure that the following is incorporated:

| TOGAF Phase                            | Folder Mapping                                           | Purpose                                                |
| -------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------ |
| **Phase B: Business Architecture**     | `environments/`, `env.hcl`                               | Environment partitions reflecting organizational units |
| **Phase C: Info Systems**              | `modules/compute/`, `modules/platform/`, `modules/data/` | Application & data architecture layers                 |
| **Phase D: Technology Architecture**   | `modules/foundation/`, `modules/security/`               | Network, IAM, KMS, firewall infrastructure             |
| **Phase E: Opportunities & Solutions** | `modules/` interfaces                                    | Reusable, composable building blocks                   |
| **Phase F: Migration Planning**        | `environments/*/0*-*/`                                   | Sequential layer deployment (01 → 05)                  |
| **Phase G: Implementation Governance** | `policies/`, `.github/workflows/`                        | Sentinel/OPA policies, CI/CD gates                     |
| **Phase H: Change Management**         | `docs/architecture-decision-records/`                    | Track architectural evolution                          |
