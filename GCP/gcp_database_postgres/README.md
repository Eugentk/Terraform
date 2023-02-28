# **Terraform template to launch GCP Postgres Data Base**

**Quick start**


Install [**Terraform**](https://www.terraform.io/downloads.html)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
Configure your [**GCP access file**](https://developers.google.com/workspace/guides/create-credentials)


The variables must be set in the **Variables.tf** file.

**Start installation**

To create DB, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`

When apply command completes, it will output the db instance postgres public ip address to connect.

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`

[More Info about other Data Base settings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)