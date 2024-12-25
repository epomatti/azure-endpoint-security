resource "azuread_user" "administrator" {
  account_enabled     = true
  user_principal_name = "${var.entraid_intune_admin_username}@${var.entraid_tenant_domain}"
  display_name        = var.entraid_intune_admin_username
  mail_nickname       = var.entraid_intune_admin_username
  password            = var.intune_user_password
  usage_location      = "BR"
}

resource "azuread_user" "endpoint_user" {
  account_enabled     = true
  user_principal_name = "${var.entraid_intune_endpoint_username}@${var.entraid_tenant_domain}"
  display_name        = var.entraid_intune_endpoint_username
  mail_nickname       = var.entraid_intune_endpoint_username
  password            = var.intune_user_password
  usage_location      = "BR"
}

resource "azuread_directory_role" "intune_administrator" {
  display_name = "Intune Administrator"
}

# FIXME: Waiting for this fix to be released: https://github.com/hashicorp/terraform-provider-azuread/issues/1526
# resource "azuread_directory_role" "security_administrator" {
#   display_name = "Security Administrator"
# }

resource "azuread_directory_role_assignment" "intune_administrator" {
  role_id             = azuread_directory_role.intune_administrator.template_id
  principal_object_id = azuread_user.administrator.object_id
}

# resource "azuread_directory_role_assignment" "security_administrator" {
#   role_id             = azuread_directory_role.security_administrator.template_id
#   principal_object_id = azuread_user.administrator.object_id
# }

resource "azurerm_role_assignment" "reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_type       = "User"
  principal_id         = azuread_user.administrator.object_id
}
