#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# provider.tf file
#
# Made by y.tkachenko@mobidev.biz
#----------------------------------------------------------------------------------------

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file("./terraform.json")
}