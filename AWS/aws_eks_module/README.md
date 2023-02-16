# **Terraform template to launch AWS Kubernetes Cluster from modules**

**Quick start**


Install [**Terraform**](https://www.terraform.io/downloads.html)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Install [**Kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

Configure your AWS access keys as environment variables, insert values in your terminal:

`export AWS_ACCESS_KEY_ID=(your access key id)`

`export AWS_SECRET_ACCESS_KEY=(your secret access key)`

**Important**

Put your [**public key**](https://www.ssh.com/ssh/keygen/) into file eks.pub in folders where it is. This key is add to the server so that you can access it by ssh.


The variables must be set in the **Variables.tf** file.

**Start installation**

To create Kubernetes Cluster, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`


**Get the credentials for EKS clusters**

```bash
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME>
```
**<CLUSTER_NAME>** is name of your EKS cluster just created.

**<REGION>** is region name in which cluster is created.

Destroy infrastructure. Go to terraform scripts folder and run:

`terraform destroy`