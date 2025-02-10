variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "allowed_public_ips" {
  type = list(string)
}

variable "vm_windows_size" {
  type = string
}

variable "create_windows_server" {
  type = bool
}

### Windows Desktop ###

variable "create_windows_desktop" {
  type = bool
}

variable "windows_desktop_size" {
  type = string
}

variable "windows_desktop_admin_username" {
  type = string
}

variable "windows_desktop_admin_password" {
  type      = string
  sensitive = true
}

variable "windows_desktop_image_publisher" {
  type = string
}

variable "windows_desktop_image_offer" {
  type = string
}

variable "windows_desktop_image_sku" {
  type = string
}

variable "windows_desktop_image_version" {
  type = string
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_intune_admin_username" {
  type = string
}

variable "entraid_intune_endpoint_username" {
  type = string
}

variable "entraid_intune_user_password" {
  type      = string
  sensitive = true
}
