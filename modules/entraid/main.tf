resource "azuread_user" "administrator" {
  account_enabled     = true
  user_principal_name = "${var.intune_user_name}@${var.entraid_tenant_domain}"
  display_name        = var.intune_user_name
  mail_nickname       = var.intune_user_name
  password            = var.intune_user_password
}

resource "azuread_directory_role" "intune_service_administrator" {
  display_name = "Intune Service Administrator"
}

resource "azuread_directory_role_assignment" "intune_service_administrator" {
  role_id             = azuread_directory_role.intune_service_administrator.template_id
  principal_object_id = azuread_user.administrator.object_id
}

resource "azurerm_role_assignment" "reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azuread_user.administrator.object_id
}
