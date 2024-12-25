output "public_ip" {
  value = azurerm_public_ip.default.ip_address
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.default.id
}
