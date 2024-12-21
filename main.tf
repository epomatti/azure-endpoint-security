terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
  }
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.workload}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "vm_windows" {
  count               = var.create_windows_server ? 1 : 0
  source              = "./modules/vm/windows"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_windows_size
}

module "vm_windows11" {
  count               = var.create_windows_11 ? 1 : 0
  source              = "./modules/vm/windows11"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_windows_size
}

# module "entraid" {
#   source                = "./modules/entraid"
#   entraid_tenant_domain = var.entraid_tenant_domain
#   intune_user_name      = var.entraid_intune_user_name
#   intune_user_password  = var.entraid_intune_user_password
#   resource_group_id     = azurerm_resource_group.default.id
# }
