locals {
  name = "win11"
}

resource "azurerm_public_ip" "default" {
  name                = "pip-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipcfg-${local.name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "default" {
  name                  = "vm-${local.name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.windows_desktop_size
  admin_username        = var.windows_desktop_admin_username
  admin_password        = var.windows_desktop_admin_password
  network_interface_ids = [azurerm_network_interface.default.id]
  secure_boot_enabled   = true

  os_disk {
    name                 = "osdisk-${local.name}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.windows_desktop_image_publisher
    offer     = var.windows_desktop_image_offer
    sku       = var.windows_desktop_image_sku
    version   = var.windows_desktop_image_version
  }
}
