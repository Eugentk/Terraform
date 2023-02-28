#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# provider.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------
provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file("./terraform.json")
}
provider "google-beta" {
  project = var.project
  region  = var.region
}
