function Get-OS {
    Param (
        [Parameter(Mandatory)]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$DCOMAuthentication
    )

    $GetCimInstanceSplat = @{
        Query = "Select Caption from Win32_OperatingSystem"
        CimSession = $Session
    }

    if ($PSBoundParameters.ContainsKey("ComputerName")) {
        $NewCimSessionSplat = @{
            ComputerName = $ComputerName
            ErrorAction  = "Stop"
        }
    }

    if ($PSBoundParameters.ContainsKey("Credential")) {
        if ($DCOMAuthentication.IsPresent) {
            $Options                             = New-CimSessionOption -Protocol Dcom
            $NewCimSessionSplat["SessionOption"] = $Options
        }
        
        $NewCimSessionSplat["Credential"]  = $Credential
        $Session                           = New-CimSession @NewCimSessionSplat
        $GetCimInstanceSplat["CimSession"] = $Session
    }

    if (-not $PSBoundParameters.ContainsKey("Credential") -And $PSBoundParameters.ContainsKey("ComputerName")) {
        $GetCimInstanceSplat["ComputerName"] = $ComputerName
    }

    Get-CimInstance @getCimInstanceSplat | Select-Object -ExpandProperty Caption

    Remove-CimSession $Session
}
