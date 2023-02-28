#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# outputs.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "VNet_ID" {
  value = azurerm_virtual_network.application-vn.id
}