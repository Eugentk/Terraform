# **Terraform template to launch GCP Virtual Machine with Docker SWARM**

**INFO**

Example of creating a virtual machine in GCP and configuring the server to deploy the application in Docker SWARM mode.

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

Put your [**private key**](https://www.ssh.com/ssh/keygen/) into folder where it is and rename on private_key. This key is required to access your server via ssh.

The variables must be set in the **Variables.tf** and **Ansible/extra_vars.json** files

The virtual machine is configured by Ansible. You can add your own docker-stack file to the docker_stack.j2 file and customize playbook.yml if you need to add new packages to install.

**Start installation**

To create VM, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`

When apply command completes, you should be able to access your application on http://Server_IP 

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`