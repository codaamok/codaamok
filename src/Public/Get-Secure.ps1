function Get-Secure {
    <#
    .SYNOPSIS
        Get a stored credential.
    .DESCRIPTION
        Get a stored credential.
        https://github.com/indented-automation/Indented.Profile/blob/master/Indented.Profile/public/Get-Secure.ps1
    #>

    [CmdletBinding(DefaultParameterSetName = 'Get')]
    param (
        # The name which identifies a credential.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ParameterSetName = 'Get')]
        [String]$Name,

        # List all available credentials.
        [Parameter(Mandatory, ParameterSetName = 'List')]
        [Switch]$List,

        # Do not copy the password to the clipboard.
        [Switch]$Clipboard,

        # Store the password in an environment variable instead of returning a credential.
        [Switch]$AsEnvironmentVariable
    )

    begin {
        if ($List) {
            Get-ChildItem $home\Documents\Keys | Select-Object @(
                @{n='Name';e={ $_.BaseName }},
                @{n='Created';e={ $_.CreationTime }}
            )
        }
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'Get') {
            $path = '{0}\Documents\Keys\{1}.xml' -f $home, $Name
            if (Test-Path $path) {
                $credential = Import-CliXml ('{0}\Documents\Keys\{1}.xml' -f $home, $Name)
                if ($AsEnvironmentVariable) {
                    Set-Item env:$Name -Value $credential.GetNetworkCredential().Password
                } else {
                    if ($Clipboard) {
                        $credential.GetNetworkCredential().Password | Set-Clipboard
                    }
                    $credential
                }
            }
        }
    }
}
