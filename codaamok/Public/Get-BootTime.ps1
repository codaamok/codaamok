Function Get-BootTime {
    Param (
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$DCOMAuthentication
    )

    $GetCimInstanceSplat = @{
        ClassName   = "Win32_OperatingSystem"
        ErrorAction = "Stop"
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

    $Win32OperationgSystem            = Get-CimInstance @GetCimInstanceSplat
    $GetCimInstanceSplat["ClassName"] = "Win32_TimeZone"
    $Win32TimeZone                    = Get-CimInstance @GetCimInstanceSplat

    [PSCustomObject]@{
        PSComputerName    = $Win32OperationgSystem.PSComputerName
        LastBootUpTimeUTC = $Win32OperationgSystem.LastBootUpTime.ToUniversalTime()
        TimeZone          = $Win32TimeZone.Caption
        Bias              = $Win32TimeZone.Bias
    }

    if ($Session) { Remove-CimSession $Session }
}
