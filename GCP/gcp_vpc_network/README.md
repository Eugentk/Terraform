# **Terraform template to launch GCP VPC and Firewall**

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

To create VPC and Firewall, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`


Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`