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
resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = var.bucket_name
}

#Enable encryption by default

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_enable" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_s3_bucket_acl" "acl_enable" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}