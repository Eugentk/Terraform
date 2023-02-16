#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# variables.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

variable "region" {
  description = "Please Enter AWS region"
  default = "eu-central-1" # Frankfurt region
}
variable "instance_type" {
  description = "Please Enter Instance Type"
  default     = "t2.small"
}
variable "volume_size" {
  description = "Please Enter volume size"
  default = "8"
}
variable "ssh_key_name" {
  description = "Please Enter ssh key name to connect for ssh"
  default     = "projectname"
}
variable "public_key_path" {
  description = "Please choose public key"
  default = "./public_key"
}
variable "main_tags" {
  description = "Common tags"
  type = map(string)
  default = {
    Maintainer : "Eugen Tkachenko"
    Project : "Terraform EC2 Mobidev"
    Environment : "Docker"
  }
}