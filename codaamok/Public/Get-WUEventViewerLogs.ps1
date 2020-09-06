Function Get-WUEventViewerLogs {
    Param (
        [Parameter()]
        [string]$ComputerName,
        [Parameter()]
        [int]$Days,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$ErrorOnly,
        [Parameter()]
        [Switch]$Installs,
        [Parameter()]
        [Switch]$Uninstalls,
        [Parameter()]
        [Switch]$ExcludeAV
    )
    $FilterHashtable = @{
        ProviderName = "Microsoft-Windows-WindowsUpdateClient"
    }
    $GetWinEventSplat = @{
        FilterHashTable = $FilterHashtable
    }
    switch ($true) {
        ($Days -gt 0) {
            $FilterHashtable["StartTime"] = (Get-Date).AddDays(-$Days)
        }
        $ErrorOnly.IsPresent {
            $FilterHashtable["Level"] = 2
        }
        $Installs.IsPresent {
            $FilterHashtable["Id"] = $FilterHashtable["Id"] + @(17,18,19,20,21,22, 43)
        }
        $Uninstalls.IsPresent {
            $FilterHashtable["Id"] = $FilterHashtable["Id"] + @(23,24)
        }
        $PSBoundParameters.ContainsKey("ComputerName") {
            $GetWinEventSplat["ComputerName"] = $ComputerName
        }
        $PSBoundParameters.ContainsKey('Credential') {
            $GetWinEventSplat["Credential"] = $Credential
        }
    }
    if ($ExcludeAV.IsPresent) {
        Get-WinEvent @GetWinEventSplat | Where-Object { $_.Message -notmatch "Definition Update" -And $_.Message -notmatch "Antivirus" }
    }
    else {
        Get-WinEvent @GetWinEventSplat
    }
}
