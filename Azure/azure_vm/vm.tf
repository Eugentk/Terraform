#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# Vm.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#                              AZ Virtual Machine
#-------------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.application-rg.location
  resource_group_name   = azurerm_resource_group.application-rg.name
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
  size                  = var.vm_size
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts"
    version   = "latest"
  }
  os_disk {
    name                 = "linux-vm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  computer_name                   = "ubuntu-linux-vm"
  admin_username                  = var.admin_username
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("./public_key")
  }
  custom_data = base64encode(data.template_file.launch_server_script.rendered)
  tags = {
    environment = var.environment
  }
}

data "template_file" "launch_server_script" {
  template = file("webserver.sh")
}
#-------------------------------------------------------------------------------
#                              Static Public for VM
#-------------------------------------------------------------------------------

resource "azurerm_public_ip" "vm-ip" {
  name                = "vm-ip"
  location            = azurerm_resource_group.application-rg.location
  resource_group_name = azurerm_resource_group.application-rg.name
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.application-rg]
}

#-------------------------------------------------------------------------------
#                              Network Card for VM
#-------------------------------------------------------------------------------

resource "azurerm_network_interface" "linux-vm-nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.application-rg.location
  resource_group_name = azurerm_resource_group.application-rg.name
  depends_on          = [azurerm_resource_group.application-rg]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-ip.id
  }
}