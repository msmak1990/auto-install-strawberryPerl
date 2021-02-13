# auto-install-strawberryPerl
Date | Modified by | Remarks
:----: | :----: | :----
2021-02-13 | Sukri Kadir | Created
2021-02-13 | Sukri Kadir | Made some cosmetic changes on README.md
---

## Description:
> * This is the PowerShell script to install **silently** the Strawberry Perl binary by getting the latest version from its official site. 
> * All done by automated way!.

Windows Version | OS Architecture | PowerShell Version | Result
:----: | :----: | :----: | :----
Windows 10 | 64-bit and 32-bit | 5.1.x | Tested. `OK`
---

### Below are steps on what script does:

No. | Steps
:----: | :----
1 | Get the configuration value from `..\Configuration\InstallationConfiguration.ini` i.e. the Strawberry Perl source installer URL
2 | Pre-validate to check for the Strawberry Perl availability in the target system
3 | Display on console if the Strawberry Perl application available in the target system
4 | Download the latest version of Strawberry Perl application from its official site
5 | Install **silently** the Strawberry Perl application
6 | Post-validate to check if the Strawberry Perl application installed successfully
---  

### How to run this script.

1. After cloning the repository, navigate into the base directory e.g. `..\auto-install-strawberryPerl\`
2. Right-click on **`Install-StrawberryPerl.cmd`** file and _run with an administration right_
---

### There are some functions involved as follows:

No. | Function Name | Description
:----: | :---- | :----
1 | `Get-IniConfiguration` | This function is used to get the contents of the .ini configuration file. It locates at `..\Modules\Get-IniConfiguration.ps1`
2 | `Get-ConfigurationValue` | This function is used to get the configuration value(s) from `Get-IniConfiguration` function. It locates at `..\Modules\Get-ConfigurationValue.ps1`
3 | `Get-Application` | This function is used to check the existence of Strawberry Perl application in the target system. It locates at `..\Scripts\Get-Application.ps1`
4 | `Get-OSArchitecture` | This function is used to check the OS architecture (64 or 32-bit) in the target system. It locates at `..\Scripts\Get-OSArchitecture.ps1`
5 | `Get-ApplicationBinary` | This function is used to download the latest Strawberry Perl installer from its official site. It locates at `..\Scripts\Get-ApplicationBinary.ps1`
6 | `Install-Application` | This function is used to install silently the Strawberry Perl application by downloading the latest version its official site. It locates at `..\Scripts\Install-Application.ps1`
4 | `InstallationConfiguration.ini` | This is the configuration file to customize a few configuration values. It locates at `..\Configuration\InstallationConfiguration.ini`

---
Example for the configuration file i.e. `InstallationConfiguration.ini`

```ini
[Application]
;it could be URL or the physical path from the local system.
SOURCE_INSTALLER = https://strawberryperl.com/releases.html
```