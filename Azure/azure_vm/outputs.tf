#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# outputs.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "VM_IP" {
  value = azurerm_linux_virtual_machine.linux-vm.public_ip_address
}