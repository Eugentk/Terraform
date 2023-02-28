#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# outputs.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------
output "Web_app_url" {
  value = nonsensitive("${azurerm_linux_web_app.app.name}.azurewebsites.net")
}