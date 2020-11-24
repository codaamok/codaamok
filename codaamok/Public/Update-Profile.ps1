Function Update-Profile {
    Invoke-WebRequest https://acook.io/profile -OutFile $profile.CurrentUserAllHosts -PassThru -ErrorAction Stop
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}
