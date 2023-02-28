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

#-------------------------------------------------------------------------------
#                              AZ Virtual Network
#-------------------------------------------------------------------------------

resource "azurerm_virtual_network" "application-vn" {
  name                = var.vn_name
  resource_group_name = azurerm_resource_group.application-rg.name
  location            = azurerm_resource_group.application-rg.location
  address_space       = var.vn_cidr

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "application-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.application-rg.name
  virtual_network_name = azurerm_virtual_network.application-vn.name
  address_prefixes     = var.vn_cidr_subnet
}

resource "azurerm_network_security_group" "application-sg" {
  name                = var.sg_name
  location            = azurerm_resource_group.application-rg.location
  resource_group_name = azurerm_resource_group.application-rg.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_rule" "app-sec-rule" {
  name                        = var.sec_rule_name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.application-rg.name
  network_security_group_name = azurerm_network_security_group.application-sg.name
}

resource "azurerm_subnet_network_security_group_association" "application-sga" {
  subnet_id                 = azurerm_subnet.application-subnet.id
  network_security_group_id = azurerm_network_security_group.application-sg.id
}