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
  zone        = var.location
  credentials = file("./terraform.json")
}
provider "google-beta" {
  project = var.project
  region  = var.region
}