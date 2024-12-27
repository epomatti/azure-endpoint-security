# output "windows_public_ip" {
#   value = module.vm_windows.public_ip
# }

output "deallocate_windows_desktop_ssh_command" {
  value = "az vm deallocate --resource-group ${azurerm_resource_group.default.name} --name ${module.vm_windows_desktop[0].name}"
}
