#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# variables.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

variable "project" {
  description = "Project name on GCP"
  default = "skillup-351113"
}
variable "region" {
  description = "GCP region"
  default = "europe-west1"
}
variable "zone" {
  description = "GCP Zone name"
  default = "europe-west1-b"
}

variable "machine_type" {
  description = "Machine type"
  default = "e2-micro"
}
variable "count_vm" {
  description = "Number vm"
  default = "3"
}
variable "disk_size" {
  description = "Boot disk size"
  default = "10"
}
variable "ssh_user" {
  description = "Put ssh user name"
  default = "tk.eugen"
}
variable "ssh_pub_key" {
  description = "Put ssh public key"
  default = "./public_key"
}