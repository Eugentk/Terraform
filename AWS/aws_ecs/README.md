# **Terraform template to launch Amazon Elastic Container Service**

**INFO**

Example of creating  Elastic Container Service (ECS) and RDS.


**Quick start**


Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Install [Terraform](https://www.terraform.io/downloads.html)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

Configure your AWS access keys as environment variables, insert values in your terminal:

`export AWS_ACCESS_KEY_ID=(your access key id)`

`export AWS_SECRET_ACCESS_KEY=(your secret access key)`

**Variables**

The variables must be set in the **Variables.tf**, **terraform.tfvars** and **locals.tf** files.

**Start installation**

To create ECS, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`

[More Info about other ECS settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)