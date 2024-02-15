# Azure Endpoint Security

Resources to Intune, Defender for Endpoint, and more.

Set the variables file:

```sh
cp config/template.tfvars .auto.tfvars
```

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

A user `IntuneAdmin@yourdomain` will be created with the following permissions:

- `Intune Administrator`
- `Security Administrator`

Using this user will be able to have access to:

- https://intune.microsoft.com
- https://security.microsoft.com

## Defender for Endpoint

Connect MDE with Intune. (Microsoft Intune Plan)


Needs addon

https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint?view=o365-worldwide

## Company Portal

A license is required.

Azure Advanced Threat Protection

Make sure to also allow MDM user scope to enroll (Mobility MDM and WIP) - Microsoft Intune


https://www.youtube.com/watch?v=z3R_aq0pu0Y


## LAPS

For Local Administrator Password Solution (LAPS), make sure you've enabled it in the device settings blade:

<img src=".assets/laps.png" />

In Intune, create an account protection policy:

1. Select Endpoint security > Account protection > Create policy
2. Select Windows 10 and Windows LAPS
3. Create the policy for all devices

## Windows 11 images

To find updated Windows 11 images:

```sh
az vm image list-skus -l eastus2 -f Windows-11 -p MicrosoftWindowsDesktop --query [].name
```

Suffix are:

| Code | Column 2 Header |
| -------------- | -------------- |
|  avd             |        Azure Virtual Desktop       |
|   ent             |       Enterprise        |
|   entn             |     Enterprise (not with media player)           |
|   pro             |     Professional           |
|   pro-zh-cn             |     Simplified Chinese          |
|   pron             |     Professional (not with media player)           |
