output "deallocate_windows_desktop_ssh_command" {
  value = var.create_windows_desktop ? "az vm deallocate --resource-group ${azurerm_resource_group.default.name} --name ${module.vm_windows_desktop[0].name}" : ""
}

output "start_windows_desktop_ssh_command" {
  value = var.create_windows_desktop ? "az vm start --resource-group ${azurerm_resource_group.default.name} --name ${module.vm_windows_desktop[0].name}" : ""
}
