#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Main.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
#-------------------------------------------------------------------------------------------
#                                   GCP-Storage Bucket
#-------------------------------------------------------------------------------------------

resource "google_storage_bucket" "bucket" {
  name            = var.name
  storage_class   = var.storage_class
  force_destroy   = var.force_destroy
  location        = var.region

  versioning {
    enabled = var.versioning_enabled
  }
  lifecycle {
    ignore_changes = []
    create_before_destroy = true
  }
}
