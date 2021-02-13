<#
.Synopsis
   Short description
    This script will be used for checking the existence of the application in the target system.
.DESCRIPTION
   Long description
    2021-02-13 Sukri Created.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
    Author : Sukri Kadir
    Email  : msmak1990@gmail.com
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function Get-Application
{
    Param
    (
    #parameter for the application installer source url.
        [ValidateNotNullOrEmpty()]
        [String]
        $ApplicationNamePattern
    )

    begin
    {
        <#BEGIN: VARIABLES DECLARATION#>
        $FileName = $MyInvocation.MyCommand.Name
        $TimeStamp = Get-Date
        $ComputerName = $env:COMPUTERNAME
        $LoggingStamp = "$TimeStamp $FileName"
        # Gets the properties of a specified item in registry for windows 32-bit/64-bit
        $HklmWow6432NodeRegistryPath = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        $HklmWindowsRegistryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
        <#END: VARIABLES DECLARATION#>
    }
    process
    {
        #pre-validate to check the application availability in the target system
        #store the registry paths into an array.
        $RegistryPathArray = @($HklmWow6432NodeRegistryPath, $HklmWindowsRegistryPath)

        #get the registry path which its value is not null.
        foreach ($RegistryPath in $RegistryPathArray)
        {
            $ApplicationProperties = Get-ItemProperty "$RegistryPath\*" | where-Object DisplayName -like $ApplicationNamePattern
            if ($ApplicationProperties)
            {
                $ApplicationRegistryPath = $RegistryPath
                $ApplicationProperty = $ApplicationProperties
            }
        }
    }
    end
    {
        #display the application version if it is available in the system
        #return true with the registry value.
        if ($ApplicationProperty)
        {
            $ApplicationVersion = $ApplicationProperty.DisplayName
            Write-Warning -Message "[$ApplicationVersion] is already installed in this system"
            return $true, $ApplicationProperty
        }

        #display an warning message if the application is not available in the system
        #return false
        if (!$ApplicationProperty)
        {
            Write-Warning -Message "[$ApplicationNamePattern] is NOT installed on this system"
            return $false
        }
    }
}