<#
.Synopsis
   Short description
    This script will be used for downloading the latest application installer from its official site.
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

function Get-ApplicationBinary
{
    Param
    (
    #parameter for the application installer source url.
        [ValidateNotNullOrEmpty()]
        [String]
        $InstallerSourceUrl
    )

    Begin
    {
        #create the request.
        $HttpRequest = [System.Net.WebRequest]::Create($InstallerSourceUrl)

        #get a response from the site.
        $HttpResponse = $HttpRequest.GetResponse()

        #get the HTTP code as an integer.
        $HttpStatusCode = [int]$HttpResponse.StatusCode

        #throw an error exception if the status code is not 200 (NOT OK).
        if ($HttpStatusCode -ne 200)
        {
            Write-Error -Message "[$InstallerSourceUrl] unable to reach out with status code [$HttpStatusCode]." -ErrorAction Stop
        }

        #get the OS architecture i.e. 32 or 64-bit in the target system
        $OSArchitecture = Get-OSArchitecture

    }
    Process
    {
        #get site contents.
        $SiteContents = Invoke-WebRequest -Uri $InstallerSourceUrl -UseBasicParsing

        #get href link.
        $SiteHrefs = $SiteContents.Links

        #a dynamic array to store the application version
        $ApplicationInstallerVersion = [system.Collections.ArrayList]@()

        #filter only uri contains the application versions with ending the postfix *.msi
        foreach ($SiteHref in $SiteHrefs[2..3])
        {
            if ($SiteHref.href -match "(\.msi)$")
            {
                $ApplicationInstallerVersion.Add($( $SiteHref.href )) | Out-Null
            }
        }

        #get OS architecture for the application binary file name.
        if ($OSArchitecture[0] -eq $true)
        {
            #for 32-bit
            if ($OSArchitecture[1] -eq "32-bit")
            {
                #get the latest application binary file name.
                $ApplicationUrlOSArchitecture = $ApplicationInstallerVersion[0]
            }

            #for 64-bit
            if ($OSArchitecture[1] -eq "64-bit")
            {
                #get the latest application binary file name.
                $ApplicationUrlOSArchitecture = $ApplicationInstallerVersion[1]
            }
        }

        $AplicationFileName = $ApplicationUrlOSArchitecture -split "/", ""


        #if no available for OS Architecture, then throw an error exception and stop the execution process
        if ($OSArchitecture[0] -eq $false)
        {
            Write-Error -Message "We cannot find your system bit (32-bit or 64-bit)." -ErrorAction Stop
        }

        #get the downloaded application directory
        $InstallerDownloadDirectory = "$( $env:USERPROFILE )\Downloads\$( $AplicationFileName[5] )"

        Write-Warning -Message "Started Download time: $( Get-Date -Format "yyyy-MM-dd HH:mm:ss" )"
        #download teh latest application binary file from its official site.
        Invoke-WebRequest -Uri $ApplicationUrlOSArchitecture -OutFile $InstallerDownloadDirectory -Verbose -TimeoutSec 60
        Write-Warning -Message "Ended Download time: $( Get-Date -Format "yyyy-MM-dd HH:mm:ss" )"

        #throw an error exception if not available for the application installer.
        if (!$( Test-Path -Path $InstallerDownloadDirectory -PathType Leaf ))
        {
            Write-Error -Message "[$InstallerDownloadDirectory] does not exist." -Category ObjectNotFound -ErrorAction Stop
        }
    }
    End
    {
        #return the full path of the application installer file.
        return $InstallerDownloadDirectory
    }
}