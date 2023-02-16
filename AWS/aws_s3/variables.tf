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
variable "bucket_name" {
  description = "Please Enter the bucket name"
  default = "terraform-state-mobidev-app"
}