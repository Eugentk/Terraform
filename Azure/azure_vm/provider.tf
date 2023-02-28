#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# provider.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
