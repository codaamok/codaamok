Function Get-WUInstalledUpdates {
    Param(
        [Parameter()]
        [string]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$ResolveKB
    )
    if ($ResolveKB.IsPresent -And (-not(Get-Module kbupdate))) {
        Import-Module "kbupdate" -ErrorAction "Stop"
    }
    $getHotFixSplat = @{
        ErrorAction = "Stop"
    }
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $getHotFixSplat['Credential'] = $Credential
    }
    if ($PSBoundParameters.ContainsKey('ComputerName')) {
        $getHotFixSplat['ComputerName'] = $ComputerName
    }
    $Updates = Get-HotFix @getHotFixSplat
    if ($ResolveKB.IsPresent) {
        $Updates | Select-Object @(
            @{l="Title";e={[String]::Join(", ", (Get-KbUpdate -Pattern $_.HotfixId -Simple).Title)}}
            "Description",
            "HotFixId",
            "InstalledBy",
            @{l="InstalledOn";e={[DateTime]::Parse($_.psbase.properties["installedon"].value,$([System.Globalization.CultureInfo]::GetCultureInfo("en-US")))}}
        )
    }
    else {
        $Updates | Select-Object @(
            "Description",
            "HotFixId",
            "InstalledBy",
            @{l="InstalledOn";e={[DateTime]::Parse($_.psbase.properties["installedon"].value,$([System.Globalization.CultureInfo]::GetCultureInfo("en-US")))}}
        )
    }
}
