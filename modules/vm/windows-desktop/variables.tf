variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
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

variable "administrator_user_object_id" {
  type = string
}

variable "endpoint_user_object_id" {
  type = string
}
