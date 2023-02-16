# **Terraform template to launch AWS EC2 instance with Docker**

**INFO**

Example of creating a EC2 instance with Docker and Docker-compose.

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

**Important**

Put your [**public key**](https://www.ssh.com/ssh/keygen/) into file public_key in folders where it is. This key is add to the server so that you can access it by ssh.


**Variables**

The variables must be set in the **Variables.tf** file (region, instance_type)

**Start installation**

To create EC2 instance, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`

When apply command completes, it will output the EC2 elastic IP

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`

[More Info about other EC2 settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)