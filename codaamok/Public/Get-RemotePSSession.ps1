function Get-RemotePSSession{
    <#
    .Synopsis
        Display WSMan Connection Info
    .DESCRIPTION
        This is a wrapper to Get-WSManInstance
    .EXAMPLE
        Get-RemotePSSession ServerABC
    .EXAMPLE
        $s = Get-RemotePSSession ServerABC
        $s | Remove-RemotePSSession
    .NOTES
        https://jrich523.wordpress.com/2012/01/19/managing-remote-wsman-sessions-with-powershell/
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string]$ComputerName,
        [Parameter()]
        [switch]$UseSSL,
        [Parameter()]
        [PSCredential]$Credential
    )
    begin
    {
        try{
            Add-Type  @"
namespace JRICH{
public class PSSessionInfo
            {
                public string Owner;
public string ClientIP;
public string SessionTime;
public string IdleTime;
public string ShellID;
public string ConnectionURI;
public bool UseSSL=false;
            }}
"@
        }
        catch{}
        $results = @()
 
    }
    process {
        $port = if($usessl){5986}else{5985}
        $URI = "http://{0}:{1}/wsman" -f $ComputerName, $port

        $GetWSManInstanceSplat = @{
            ConnectionURI = $URI
            ResourceURI = "shell"
            Enumerate = $true
        }
        
        if ($PSBoundParameters.ContainsKey("Credential")) {
            $GetWSManInstanceSplat["Credential"] = $Credential
        }
        
        $sessions = Get-WSManInstance @GetWSManInstanceSplat
 
        foreach($session in $sessions) {
            $obj = New-Object jrich.pssessioninfo
            $obj.owner = $session.owner
            $obj.clientip = $session.clientIp
            $obj.sessiontime = [System.Xml.XmlConvert]::ToTimeSpan($session.shellRunTime).tostring()
            $obj.idletime = [System.Xml.XmlConvert]::ToTimeSpan($session.shellInactivity).tostring()
            $obj.shellid = $session.shellid
            $obj.connectionuri = $uri
            $obj.UseSSL = $usessl
            $results += $obj
        }
    }
    end
    {
        $results
    }
}
