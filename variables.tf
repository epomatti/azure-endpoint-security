variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "vm_windows_size" {
  type = string
}

variable "create_windows_server" {
  type = bool
}

variable "create_windows_11" {
  type = bool
}

### Entra ID ###
# variable "entraid_tenant_domain" {
#   type = string
# }

# variable "entraid_intune_user_name" {
#   type = string
# }

# variable "entraid_intune_user_password" {
#   type      = string
#   sensitive = true
# }
