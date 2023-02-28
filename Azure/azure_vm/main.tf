#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# Main.tf file
#
# Made by Tk.eugen@gmail.com
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

