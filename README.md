# gcp_terraform_template
# Created by Julius Pelejo

Terraform Multi Environment Template


The purpose of creating the repository is to give an example of how to create a multi environment template with vault capabilities.  

Best practice is to have the Terraform files
1.  No hard coded values
2.  Save in an encrypted storage area with limited access
3.  Enable the versioning for the storage area
4.  Use the vault or Secrets Manager to hide credentials that may be used for datasources, APIs, etc.

Using a parent / child folder structure helps structure the files in a way where if there are common attributes such as provider information, it is not repeated in the child folders and derived from the parent folders.  Reusability is the key to efficiency.
