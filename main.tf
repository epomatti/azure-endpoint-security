terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0.0"
    }
  }
}

resource "random_string" "affix" {
  length  = 5
  special = false
  numeric = false
  upper   = false
}

locals {
  affix          = random_string.affix.result
  resource_affix = "${var.workload}${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.resource_affix}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  allowed_public_ips  = var.allowed_public_ips
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${local.resource_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "vm_windows_server" {
  count               = var.create_windows_server ? 1 : 0
  source              = "./modules/vm/windows-server"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_windows_size
}

module "vm_windows_desktop" {
  count                           = var.create_windows_desktop ? 1 : 0
  source                          = "./modules/vm/windows-desktop"
  workload                        = local.resource_affix
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  subnet_id                       = module.vnet.subnet_id
  windows_desktop_size            = var.windows_desktop_size
  windows_desktop_admin_username  = var.windows_desktop_admin_username
  windows_desktop_admin_password  = var.windows_desktop_admin_password
  windows_desktop_image_publisher = var.windows_desktop_image_publisher
  windows_desktop_image_offer     = var.windows_desktop_image_offer
  windows_desktop_image_sku       = var.windows_desktop_image_sku
  windows_desktop_image_version   = var.windows_desktop_image_version
  administrator_user_object_id    = module.entraid.administrator_user_object_id
  endpoint_user_object_id         = module.entraid.endpoint_user_object_id
}

module "entraid" {
  source                           = "./modules/entraid"
  entraid_tenant_domain            = var.entraid_tenant_domain
  entraid_intune_admin_username    = var.entraid_intune_admin_username
  entraid_intune_endpoint_username = var.entraid_intune_endpoint_username
  intune_user_password             = var.entraid_intune_user_password
  resource_group_id                = azurerm_resource_group.default.id
}

locals {
  readers_list = [module.entraid.administrator_user_object_id, module.entraid.endpoint_user_object_id]
}

resource "azurerm_role_assignment" "readers" {
  count                = length(local.readers_list)
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Reader"
  principal_id         = local.readers_list[count.index]
}
