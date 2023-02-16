#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# Main.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }
}
provider "aws" {
  region = var.region #Main region
}

