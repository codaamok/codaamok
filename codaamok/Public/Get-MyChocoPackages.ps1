function Get-MyChocoPackages {
    param (
        [String[]]$Exclude,
        [Switch]$IncludeDellUpdate
    )
    $Packages = @(
        "Everything"
        "powertoys"
        "git"
        "vscode"
        "7zip"
        "pwsh"
        "rdmfree"
        "discord"
        "slack"
        "whatsapp"
        "GoogleChrome"
        "microsoft-windows-terminal"
        "ditto"
        "obs-studio"
        "cue"
        "sharex"
        "altdrag"
    )
    if ((Get-CimInstance -ClassName "Win32_ComputerSystem").Manufacturer -match "dell" -Or $IncludeDellUpdate.IsPresent) {
        $Packages += "dell-update"
    }
    $Packages | Where-Object { $Exclude -notcontains $_ }
}
