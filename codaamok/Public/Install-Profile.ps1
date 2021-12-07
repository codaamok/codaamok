function Install-Profile {
    Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $profile.CurrentUserAllHosts -Confirm -ErrorAction "Stop"
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}