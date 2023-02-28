#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# variables.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

# Account settings

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources"
}
variable "client_id" {
  description = " Enter Client ID for Application"
}
variable "client_secret" {
  description = "Enter Client secret for Application"
}
variable "tenant_id" {
  description = "Enter Tenant ID"
}

# Resource Group

variable "resource_group_name" {
  description = "Enter Resource group name"
  default     = "terra"
}
variable "resource_group_location" {
  description = "Enter Resource group location"
  default     = "West Europe"
}

variable "environment" {
  description = "Enter environment"
  default     = "Stage"
}
# Virtual Network

variable "vn_name" {
  description = "Enter name for VNet"
  default     = "skyfall"
}
variable "subnet_name" {
  description = "Enter VNet subnet name"
  default     = "skyfall_subnet"
}
variable "vn_cidr" {
  description = "CIDR for the whole VNet"
  type = list(string)
  default     = ["172.10.0.0/16"]
}

variable "vn_cidr_subnet" {
  description = "CIDR for the VNet Subnet"
  type = list(string)
  default     = ["172.10.1.0/24"]
}

variable "sg_name" {
  description = "Enter security group name"
  default     = "web"
}
variable "sec_rule_name" {
  description = "Enter security rule name"
  default     = "allow_ssh"
}