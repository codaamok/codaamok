Function Update-Profile {
    try {
        $R = Invoke-WebRequest https://www.cookadam.co.uk/profile -OutFile $profile.CurrentUserAllHosts -PassThru -ErrorAction Stop
    }
    catch {
        Write-Host "Error: " -ForegroundColor Red -NoNewline
        Write-Host $Error[0].Exception.Message
    }
    If ($R.StatusCode -eq 200) {
        '. $profile.CurrentUserAllHosts' | clip
        Write-Host "Paste your clipboard"
    }
}
