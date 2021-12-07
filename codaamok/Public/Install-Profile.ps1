function Install-Profile {
    $Module = Get-Module codaamok -PassThru -ErrorAction "Stop"
    Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $profile.CurrentUserAllHosts -Confirm -ErrorAction "Stop"
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}