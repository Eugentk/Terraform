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
    random = {
      source = "hashicorp/random"
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
#                              AZ Web App
#-------------------------------------------------------------------------------

resource "azurerm_service_plan" "plan" {
  name                = "service-${local.service_plan_id}"
  location            = azurerm_resource_group.application-rg.location
  resource_group_name = azurerm_resource_group.application-rg.name
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "app" {
  name                = "web-app-${local.service_plan_id}"
  location            = azurerm_resource_group.application-rg.location
  resource_group_name = azurerm_resource_group.application-rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    use_32_bit_worker = true
    always_on         = false
    application_stack {
      docker_image     = var.docker_image
      docker_image_tag = var.docker_image_tag
    }
  }
  app_settings = {
    "Api_key" = "2356656855565"
    "Code"    = "abc1234"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com"
  }
}

resource "random_password" "name" {
  length  = 4
  special = false
  upper   = false
}




