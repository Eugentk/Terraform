#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# Main.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.11.0"
    }
  }
}

#-------------------------------------------------------------------------------
#                              AZ Resource Group
#-------------------------------------------------------------------------------

resource "azurerm_resource_group" "application-rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    environment = var.environment
  }
}

#-------------------------------------------------------------------------------
#                              AZ Storage Account
#-------------------------------------------------------------------------------

resource "azurerm_storage_account" "az_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.application-rg.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "az_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.az_storage.name
  container_access_type = "container" # The Access Level configured for this Container. Possible values are blob, container or private.
}

resource "azurerm_storage_blob" "blob" {
  name                   = "sample-file"
  storage_account_name   = azurerm_storage_account.az_storage.name
  storage_container_name = azurerm_storage_container.az_container.name
  type                   = "Block"
  source                 = "welcome.jpg"
}