variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_intune_admin_username" {
  type = string
}

variable "entraid_intune_endpoint_username" {
  type = string
}

variable "intune_user_password" {
  type      = string
  sensitive = true
}

variable "resource_group_id" {
  type = string
}
