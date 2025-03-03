# Azure Endpoint Security

Sample resources for Intune, Defender for Endpoint, and more.

## Setup

Set the variables file:

```sh
cp config/local.auto.tfvars .auto.tfvars
```

Set the **required variables**:

```terraform
subscription_id       = ""
entraid_tenant_domain = ""
allowed_public_ips    = [""]
```

> [!TIP]
> Check for the latest [Windows images](#windows-images) available.

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

### Users

> [!IMPORTANT]
> You must manually assign an Intune [license](https://learn.microsoft.com/en-us/mem/intune/fundamentals/licenses) to all users.

The users described in this section will be created.

#### Intune administrator

A user named `IntuneAdmin@example.com` will be created to manage Intune.

The following roles will be assigned:

- `Intune Administrator`
- `Security Administrator`

This will allow access to the following applications:

- https://intune.microsoft.com
- https://security.microsoft.com

#### Endpoint user

A user named `EndpointUser@example.com` will be created to operate the endpoint.

Depending on the architecture, the device enrollment can take one of these forms:

- [Registered device](https://learn.microsoft.com/en-us/entra/identity/devices/concept-device-registration)
- [Joined device](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join)
- [Hybrid joined device](https://learn.microsoft.com/en-us/entra/identity/devices/concept-hybrid-join)


## Defender for Endpoint

Connect MDE with Intune. (Microsoft Intune Plan)

> 💡 An addon or equivalent [license][1] needs to be purchased for this integration.

Microsoft Defender Antivirus [works together][2] with Microsoft Defender for Endpoint

Intune EDR policy (onboard)

This [video][3] shows how to configure Device Guard with Microsoft Intune.

> 💡 Device guard - Prevents malicious code from running by ensuring only allowed and known good code can run, such as malware or ransomware. (Only Windows Enterprise client)

Among other available services is [controlled folder access][4].

## Admins

Guests may be allowed as administrators through the [unlicensed admins](https://learn.microsoft.com/en-us/mem/intune/fundamentals/unlicensed-admins) option.

Device-only licenses are [also available](https://learn.microsoft.com/en-us/mem/intune/fundamentals/licenses#device-only-licenses) for devices that are not associated with a user.

## Company Portal

A license is also required. EDR enables Azure Advanced Threat Protection

Make sure to also allow MDM user scope to enroll (Mobility MDM and WIP) - Microsoft Intune

> 💡 This helpful video shows how to enable Defender for Endpoint.

## LAPS

For Local Administrator Password Solution (LAPS), make sure you've enabled it in the device settings blade:

<img src=".assets/laps.png" />

In Intune, create an account protection policy:

1. Select Endpoint security > Account protection > Create policy
2. Select Windows 10 and Windows LAPS
3. Create the policy for all devices

## Intune

If MDE is enabled, it can take a while after joining Intune until everything is synced.

<img src=".assets/intune-endpoint.png" />

Access will be granted after the compliance check:

<img src=".assets/intune-status.png" />


## Configuration as Code

Microsoft has provided [instructions](https://techcommunity.microsoft.com/blog/intunecustomersuccess/configuration-as-code-for-microsoft-intune/3701792) on how to manage configuration as code for Intune.

## Web protection

This section shows [web protection][6].

### Attack Surface Reduction - Web protection

An example with Microsoft Edge:

<img src=".assets/intune-webprotection.png" />

Select the appropriate configuration for the profile:

<img src=".assets/intune-webprotection-profile.png" />

To test SmartScreen, use a [sample URL][7], such as this [demo malware][8] page.

<img src=".assets/intune-smartscreen.png" />

Security can be further enhanced with [Alerts][9], and monitoring can use [Reports][10].

### Defender - Web content filtering

With MDE, it is also possible to turn on web content filtering:

<img src=".assets/intune-defender-webcontentfiltering.png" />

Protection includes: adult content, high bandwidth, legal liability, leisure, and uncategorized.

A policy can be created using a blade in the same view above, like this:

<img src=".assets/intune-defender-webcontentfiltering2.png" />

## Device Guard

Credential guard, VBS, and UEFI, memory integrity, etc.

<img src=".assets/intune-deviceguard.png" />

## Security Policies

### Entra ID Authentication

When using a virtual machine as opposed to the real device, follow [this procedure](https://learn.microsoft.com/en-us/entra/identity/devices/howto-vm-sign-in-azure-ad-windows) to enable Entra ID authentication.

> [!NOTE]
> The required RBAC roles already already added by the Terraform configuration

Example using the Azure CLI command:

```sh
az vm extension set --publisher Microsoft.Azure.ActiveDirectory --name AADLoginForWindows --resource-group rg-endpoint --vm-name vm-win11
```

> [!IMPORTANT]
> Before signing in to the VM, make sure to do the first login with the user account and register the MFA.

Download the RPD file and login.

### BitLocker / Disk Encryption

Create the encryption policy and assign to the groups.

Control the conditional access depending on your use case.

Make sure the device is a member of the Entra ID assigned group.

### Antivirus

Create the antivirus policies:

#### Defender Update Controls

Antivirus updates (like security intelligence, engine updates, and platform updates) are delivered and applied.

#### Microsoft Defender Antivirus

Updates to the antivirus behavior ( real-time protection, scanning options, tamper protection, and remediation actions).

### Device Lock

Add a new policy:

1. Device > Configuration Profiles >  Settings catalog
2. + Add Settings > Device Lock > Max Inactivity Time Device Lock
3. Toggle "Device Password Enabled" to `Enabled`
4. Set the time to the desired value (in minutes)

### Apps

> [!TIP]
> You can choose for it to be available as a featured app in the Company Portal. Also, choose if required or available.

Check the [troubleshoot](https://learn.microsoft.com/en-us/troubleshoot/mem/intune/app-management/troubleshoot-app-install) article in case of issues. For example, this URL will help with installation issues:

```
https://aka.ms/IntuneAppDeployment
```

https://learn.microsoft.com/en-us/troubleshoot/mem/intune/app-management/apps-appear-unavailable

#### Install an App

1. In the `Apps` blade, create a new policy.
2. Select a source, such as Microsoft Store.
3. Select an app, such as DBeaver.

#### Remove an App

1. In the `Apps` blade, create a new policy.
2. Select a source, such as Microsoft Store.
3. In the assignment, select to uninstall an app.

### Disable AutoPlay

To check the AutoPlay configuration:

1. Open `gpedit.msc`
2. Computer Configuration → Administrative Templates → Windows Components → AutoPlay Policies

The configuration should be `Not Configured`.

To create the policy on Intune, following this [reference](https://learn.microsoft.com/en-us/answers/questions/726088/disable-removable-drive-autorun-in-azure-ad) to set up [device restrictions](https://learn.microsoft.com/en-us/mem/intune/configuration/device-restrictions-configure):

1. Create a profile, settings option
2. Search for `AutoPlay`
3. Select all options (10 in total)

Test by inserting a USB drive with an `autorun.inf` file. Ensure no automatic execution occurs.

### Compliance

Create a compliance policy and assign to the required devices.

## Other Services

https://learn.microsoft.com/en-us/mem/intune/apps/app-management

https://github.com/microsoft/Intune-PowerShell-SDK

## Windows images

### Windows Server

To find updated Windows Server images:

```sh
az vm image list-skus -l eastus2 -p MicrosoftWindowsServer -f WindowsServer --query [].name
```

### Windows 11

To find updated Windows 11 images:

```sh
az vm image list-skus -l eastus2 -p MicrosoftWindowsDesktop -f Windows-11 --query [].name
```

Suffixes details:

| Code       | Description                          |
|------------|--------------------------------------|
|  avd       | Azure Virtual Desktop                |
|  ent       | Enterprise                           |
|  entn      | Enterprise (not with media player)   |
|  pro       | Professional                         |
|  pro-zh-cn | Simplified Chinese                   |
|  pron      | Professional (not with media player) |


[1]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint?view=o365-worldwide
[2]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/why-use-microsoft-defender-antivirus?view=o365-worldwide
[3]: https://youtu.be/wAiH_lDveug
[4]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/enable-controlled-folders?view=o365-worldwide
[5]: https://www.youtube.com/watch?v=z3R_aq0pu0Y
[6]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/web-threat-protection?view=o365-worldwide
[7]: https://demo.wd.microsoft.com/Page/UrlRep
[8]: https://demo.smartscreen.msft.net/other/malware.html
[9]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/web-protection-response?view=o365-worldwide
[10]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/web-protection-monitoring?view=o365-worldwide
[11]: https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/web-content-filtering?view=o365-worldwide
