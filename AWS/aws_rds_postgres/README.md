# **Terraform template to launch AWS RDS Postgres**

**INFO**

Example of creating your own VPC with subnets and Postgres RDS.

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

The variables must be set in the **Variables.tf** file

**Start installation**

To create VPC, you need to run the following commands:
 
`terraform init`

`terraform plan`

`terraform apply`

When apply command completes, it will output the db instance endpoint and db port

Destroy infrastructure. Go to the terraform scripts folder and run: 

`terraform destroy`

[More Info about other RDS settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)