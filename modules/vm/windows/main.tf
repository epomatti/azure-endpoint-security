resource "azurerm_public_ip" "default" {
  name                = "pip-windows"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "windows" {
  name                = "nic-windows"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "windows"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                  = "vm-windows"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = "winsuer"
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    name                 = "osdisk-windows"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

# resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
#   name                       = "AzureMonitorWindowsAgent"
#   virtual_machine_id         = azurerm_windows_virtual_machine.windows.id
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorWindowsAgent"
#   type_handler_version       = "1.23" # TODO: Should be 1.22 but it is failing
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = true
# }
