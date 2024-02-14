variable "location" {
  type    = string
  default = "eastus2"
}

variable "workload" {
  type = string
}

variable "vm_windows_size" {
  type = string
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_intune_user_name" {
  type = string
}

variable "entraid_intune_user_password" {
  type      = string
  sensitive = true
}
