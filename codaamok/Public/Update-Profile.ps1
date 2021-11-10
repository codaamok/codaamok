Function Update-Profile {
    $Module = Get-Module codaamok 
    Copy-Item -Path $Module.ModuleBase\profile.ps1 -Destination $profile.CurrentUserAllHosts -Confirm
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}
