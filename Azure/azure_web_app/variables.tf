#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# variables.tf file
#
# Made by y.tkachenko@mobidev.biz
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
  default     = "Production"
}

# Web App

variable "os_type" {
  description = "Enter OS Type"
  default     = "Linux" # The OS type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer.
}

variable "sku_name" {
  description = "Enter SKU Name"
  default     = "F1"
}

variable "docker_image" {
  description = "Enter your Docker image name"
  default     = "nginxdemos/hello"
}

variable "docker_image_tag" {
  description = "Enter your Docker image tag"
  default     = "latest"
}