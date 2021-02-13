<#
.Synopsis
   Short description
    This script will be used for installing silently the .msi application by downloading the latest version its official site.
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

#import the external module into this script.
. "$( Resolve-Path -Path $( Join-Path -Path $PSScriptRoot -Resolve ".." ) )\Modules\Get-ConfigurationValue.ps1"
. "$PSScriptRoot\Get-OSArchitecture.ps1"
. "$PSScriptRoot\Get-Application.ps1"
. "$PSScriptRoot\Get-ApplicationBinary.ps1"

#configuration file name.
$ConfigurationFileName = "InstallationConfiguration.ini"

#get the ini configuration file name.
$ConfigurationIniFile = "$( Resolve-Path -Path $( Join-Path -Path $PSScriptRoot -Resolve ".." ) )\Configuration\$ConfigurationFileName"

#get the configuration values.
$SourceInstallerUrl = Get-ConfigurationValue -ConfigurationIniFile $ConfigurationIniFile -ConfigurationIniSection "Application" -ConfigurationIniKey "SOURCE_INSTALLER"

#function to install silently the application.
function Install-Application
{
    Param
    (
    #parameter for the base binary directory.
        [ValidateNotNullOrEmpty()]
        [String]
        $SourceInstallerUrl = $SourceInstallerUrl
    )

    Begin
    {
        #throw an error exception if no available for the source url.
        if (!$SourceInstallerUrl)
        {
            Write-Error -Message "There was NO application URL available from [$ConfigurationFileName] file" -ErrorAction Stop
        }
    }
    Process
    {
        #pre-validate to check for the application availability in the target system.

        #if available, then show its version on console.
        $isApplication = Get-Application -ApplicationNamePattern "*Strawberry*"
        if ($isApplication[0] -eq $true)
        {
            exit
        }

        #if not available, then install it accordingly.
        #pre-validate the OS architecture for the target system.
        #download the latest version of the application from its official site.
        $BinaryFile = Get-ApplicationBinary -InstallerSourceUrl $SourceInstallerUrl

        #install it silently.
        $InstallationProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $BinaryFile, "/passive", "/norestart" -Wait -NoNewWindow -Verbose -ErrorAction Stop

        #throw an error exception if failure to install its binary.
        if ($InstallationProcess.ExitCode -ne 0)
        {
            Write-Error -Message "[$BinaryFile] failed to install with exit code [$( $InstallationProcess.ExitCode )]." -ErrorAction Stop
        }
    }
    End
    {
        #final validation step.
        $isApplication = Get-Application -ApplicationNamePattern "*Strawberry*"
        if ($isApplication[0] -eq $false)
        {
            Write-Warning -Message "The application is NOT successfully installed in this system." -ErrorAction Continue
        }
    }
}

#start to write the log into a log file.
Start-Transcript -Path "$PSScriptRoot\$( $MyInvocation.MyCommand.Name )`.log"

#execute the function.
Install-Application

#stop the logging.
Stop-Transcript