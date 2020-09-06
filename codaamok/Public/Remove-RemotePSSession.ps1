function Remove-RemotePSSession {
    <#
    .Synopsis
        Logoff remote WSMAN session
    .DESCRIPTION
        This function will take a JRICH.PSSessionInfo object and disconnect it
    .EXAMPLE
        $s = Get-RemotePSSession ServerABC
        $s | Remove-RemotePSSession
    .NOTES
        https://jrich523.wordpress.com/2012/01/19/managing-remote-wsman-sessions-with-powershell/
    #>
    [CmdletBinding()]
    param (
        # Session to be removed.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [jrich.pssessioninfo[]]$Session,
        [Parameter()]
        [PSCredential]$Credential
    )
    process {
        foreach($connection in $session) {
            $RemoveWSManInstanceSplat = @{
                ConnectionURI = $connection.connectionuri
                ResourceURI = "shell"
                SelectorSet = @{ShellID=$connection.shellid}
            }
            if ($PSBoundParameters.ContainsKey("Credential")) {
                $RemoveWSManInstanceSplat["Credential"] = $Credential
            }
            Remove-WSManInstance @RemoveWSManInstanceSplat
        }
    }
}
