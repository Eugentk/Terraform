# **Terraform template to launch GCP Kubernetes Cluster from modules**

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
 
Configure path for you access file in the **provider.tf** file. 

The variables must be set in the **Variables.tf** file. 

**Start installation**

Export your permissions with the following command. This is required by the google-beta provider.

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Documents/gcp_gke_module/terraform.json"
```

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

**Optional: Deploy a test application**

Run `kubectl apply -f test-app/nginx.yml` to create a deployment in your cluster.

Run `kubectl get pods` to view the pod status and check that it is ready.

Run `kubectl get deployment` to view the deployment status.

Run `kubectl port-forward deployment/nginx 8080:80`

Now you should be able to access your nginx deployment on http://localhost:8080

Destroy infrastructure. Go to the terraform scripts folder and run:

`terraform destroy`