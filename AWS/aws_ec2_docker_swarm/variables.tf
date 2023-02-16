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
# EC2 Variables

variable "instance_type" {
  description = "Please Enter Instance Type"
  default     = "t2.small"
}
variable "volume_size" {
  description = "Please Enter volume size"
  default     = "8"
}
variable "ssh_user" {
  description = "Please Enter username to connect for ssh"
  default     = "ubuntu"
}
variable "ssh_key_name" {
  description = "Please Enter ssh key name to connect for ssh"
  default     = "projectname"
}
variable "public_key_path" {
  description = "Please choose public key"
  default     = "./public_key"
}
variable "private_key_path" {
  description = "Please choose public key"
  default     = "./private_key"
}

# VPC Variables

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
    Project : "Terraform VPC Mobidev"
    Environment : "Dev"
  }
}