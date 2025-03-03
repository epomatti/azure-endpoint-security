data "azuread_client_config" "current" {}

locals {
  client_object_id = data.azuread_client_config.current.object_id
}

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

resource "azuread_group" "intune_endpoint_users" {
  display_name     = "Intune Endpoint Users"
  owners           = [local.client_object_id]
  security_enabled = true
}

resource "azuread_group" "intune_endpoints" {
  display_name     = "Intune Endpoints"
  owners           = [local.client_object_id]
  security_enabled = true
}

resource "azuread_group_member" "example" {
  group_object_id  = azuread_group.intune_endpoint_users.object_id
  member_object_id = azuread_user.endpoint_user.object_id
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
