# **Terraform template to launch GCP Kubernetes Cluster**

**Quick start**


Install [**Terraform**](https://www.terraform.io/downloads.html)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
Install [**gcloud CLI**](https://cloud.google.com/sdk/docs/install#deb)

Install [**Kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

Configure your [**GCP access file**](https://developers.google.com/workspace/guides/create-credentials)


The variables must be set in the **Variables.tf** file.

**Start installation**

To create Kubernetes Cluster, you need to run the following commands:

`terraform init`

`terraform plan`

`terraform apply`


**Get the credentials for GKE clusters**

```bash
gcloud container clusters get-credentials <CLUSTER_NAME> --zone <ZONE_NAME> --project <PROJECT_ID>
```
**<CLUSTER_NAME>** is name of your GKE cluster just created.

**<ZONE_NAME>** is zone name in which cluster is created.

**<PROJECT_ID>** is project id in which cluster is created.

OR
Go to GCP console >> GKE clusters >> click on menu dots & click on connect >> copy the command

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`