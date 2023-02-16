#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# variables.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

variable "region" {
  description = "Please Enter AWS region"
  default     = "eu-central-1" # Frankfurt region
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.10.0.0/16"
}

variable "vpc_cidr_public" {
  description = "CIDR for the Public subnet"
  default     = "172.10.0.0/24"
}

variable "vpc_cidr_private" {
  description = "CIDR for the Private subnet"
  default     = "172.10.1.0/24"
}

variable "main_tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Maintainer : "Eugen Tkachenko"
    Project : "Terraform VPC"
    Environment : "Dev"
  }
}
