# **Terraform template to launch GCP Virtual Machine with Load Balancer**

**Quick start**


Install [**Terraform**](https://www.terraform.io/downloads.html)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
Configure your [**GCP access file**](https://developers.google.com/workspace/guides/create-credentials)

**Important**

Put your [**public key**](https://www.ssh.com/ssh/keygen/) into file public_key in folders where it is. This key is add to the server so that you can access it by ssh.


The variables must be set in the **Variables.tf** file.

**Start installation**

To create VM, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`

When apply command completes, you can log in to the server via ssh.

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`