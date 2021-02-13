<#
.Synopsis
   Short description
    This script will be used for getting the contents of the ini configuration file.
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
function Get-IniConfiguration
{
    Param
    (
        #parameter for the ini configuration file in full path.
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationIniFile
    )

    Begin
    {
        #throw an error exception if configuration file is not a file.
        if (!$( Test-Path -Path $ConfigurationIniFile -PathType Leaf ))
        {
            Write-Error -Message "[$ConfigurationIniFile] MUST be a file. Exit." -ErrorAction Stop
        }

        #initialize a variable in a hash array.
        $ini = @{ }
    }
    Process
    {
        switch -regex -file $ConfigurationIniFile
        {
            #section name.
            "^\[(.+)\]" # Section
            {
                $section = $matches[1]
                $ini[$section] = @{ }
                $CommentCount = 0
            }

            #ignore the comment from the ini configuration contents.
            "^(;.*)$"
            {
                $value = $matches[1]
                $CommentCount = $CommentCount + 1
                $name = "Comment" + $CommentCount
                $ini[$section][$name] = $value
            }

            #save the ini values into a hash array.
            "(.+?)\s*=(.*)" # Key
            {
                $name, $value = $matches[1..2]
                $ini[$section][$name] = $value
            }
        }
    }
    End
    {
        return $ini
    }
}