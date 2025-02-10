output "administrator_user_object_id" {
  value = azuread_user.administrator.object_id
}

output "endpoint_user_object_id" {
  value = azuread_user.endpoint_user.object_id
}
