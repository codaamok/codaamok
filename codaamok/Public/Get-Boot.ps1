Function Get-Boot {
    Param (
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential
    )
    $HashArguments = @{
        ClassName = "Win32_OperatingSystem"
    }
    if ($PSBoundParameters.ContainsKey("ComputerName")) {
        $HashArguments["ComputerName"] = $ComputerName
    }
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $HashArguments["Credential"] = $Credential
    }
    Get-CimInstance @HashArguments | Select-Object PSComputerName, LastBootUpTime
}
