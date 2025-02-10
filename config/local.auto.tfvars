# General
subscription_id    = "00000000-0000-0000-0000-000000000000"
location           = "brazilsouth"
workload           = "endpoint"
allowed_public_ips = ["1.2.3.4/32"]

# Windows Server
vm_windows_size       = "Standard_B8s_v2"
create_windows_server = false

# Windows Desktop
create_windows_desktop          = true
windows_desktop_size            = "Standard_B8s_v2"
windows_desktop_admin_username  = "azureuser"
windows_desktop_admin_password  = "P@ssw0rd.123"
windows_desktop_image_publisher = "MicrosoftWindowsDesktop"
windows_desktop_image_offer     = "Windows-11"
windows_desktop_image_sku       = "win11-24h2-ent"
windows_desktop_image_version   = "latest"

# Entra ID
entraid_tenant_domain            = "<EXAMPLE.COM>"
entraid_intune_admin_username    = "IntuneAdmin"
entraid_intune_endpoint_username = "EndpointUser"
entraid_intune_user_password     = "P@ssw0rd.123"
