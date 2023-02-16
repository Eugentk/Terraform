#-------------------------------------------------------------------------------
#                                 Main
#-------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Repository when save state file
terraform {
  backend "s3" {
    bucket = "S3-terraform-tfstate"
    key    = "app/" # Path when save tfstate file
    region = "eu-west-2"
  }
}


