function Get-OS {
    Param (
        [Parameter(Mandatory)]
        [String]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential
    )
    $newCimSessionSplat = @{
        ComputerName = $ComputerName
        ErrorAction = "Stop"
    }
    if ($PSBoundParameters.ContainsKey("Credential")) {
        $newCimSessionSplat["Credential"] = $Credential
    }
    $Session = New-CimSession @newCimSessionSplat 
    $getCimInstanceSplat = @{
        Query = "Select Caption from Win32_OperatingSystem"
        CimSession = $Session
    }
    Get-CimInstance @getCimInstanceSplat | Select-Object -ExpandProperty Caption
    Remove-CimSession $Session
}
