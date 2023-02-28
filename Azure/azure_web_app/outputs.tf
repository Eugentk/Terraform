#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# outputs.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------
output "Web_app_url" {
  value = nonsensitive("${azurerm_linux_web_app.app.name}.azurewebsites.net")
}