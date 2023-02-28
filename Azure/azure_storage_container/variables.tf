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

# Storage

variable "storage_account_name" {
  type        = string
  description = "Storage Account name in Azure"
  default     = "production110820222"
}

variable "storage_container_name" {
  type        = string
  description = "Storage Container name in Azure"
  default     = "file-share"
}