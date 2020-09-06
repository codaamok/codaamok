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
        "vim"
        "7zip"
        "pwsh"
        "royalts-v5"
        "discord"
        "slack"
        "whatsapp"
        "GoogleChrome"
        "microsoft-edge"
        "microsoft-windows-terminal"
        "ditto"
        "obs-studio"
        "cue"
        "snagit"
        "eddie"
        "altdrag"
    )
    if ((Get-CimInstance -ClassName "Win32_ComputerSystem").Manufacturer -match "dell" -Or $IncludeDellUpdate.IsPresent) {
        $Packages += "dell-update"
    }
    $Packages | Where-Object { $Exclude -notcontains $_ }
}
