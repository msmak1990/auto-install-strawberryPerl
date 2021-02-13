<#
.Synopsis
   Short description
    This script will be used for getting the configuration value from the ini configuration file.
.DESCRIPTION
   Long description
    2021-02-07 Sukri Created.
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
. "$PSScriptRoot\Get-IniConfiguration.ps1"

function Get-ConfigurationValue
{
    Param
    (
    #parameter for the ini configuration file in full path.
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationIniFile,

    #parameter for the ini configuration section name.
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationIniSection,

    #parameter for the ini configuration key name.
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationIniKey
    )

    Begin
    {
        #get the ini configuration contents.
        $ConfigurationValues = Get-IniConfiguration -ConfigurationIniFile $ConfigurationIniFile
    }
    Process
    {
        #get the configuration value.
        $ConfigurationValue = $ConfigurationValues[$ConfigurationIniSection][$ConfigurationIniKey]

        #trim any space at the begin and end of the string.
        $ConfigurationValue = $ConfigurationValue.Trim()

        #invoke the command if the string contains a command.
        if ($ConfigurationValue -match "\$\(.*")
        {
            $ConfigurationValue = Invoke-Expression -Command $ConfigurationValue
        }

    }
    End
    {
        return $ConfigurationValue
    }
}