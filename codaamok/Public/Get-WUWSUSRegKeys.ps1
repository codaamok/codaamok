Function Get-WUWSUSRegKeys {
    Param( 
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential
    )
    $InvokeCommandSplat = @{
        ScriptBlock = {
            [PSCustomObject]@{
                WUServer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUServer" -ErrorAction "SilentlyContinue").WUServer
                WUStatusServer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUStatusServer" -ErrorAction "SilentlyContinue").WUStatusServer
                UseWUServer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -ErrorAction "SilentlyContinue").UseWUServer
                ComputerName = $env:COMPUTERNAME
            }
        }
    }
    if ($PSBoundParameters.ContainsKey("Credential")) {
        $InvokeCommandSplat["Credential"] = $Credential
    }
    $Jobs = ForEach($Computer in $ComputerName) {
        if ($PSBoundParameters.ContainsKey("ComputerName")) {
            $InvokeCommandSplat["ComputerName"] = $Computer
        }
        Invoke-Command @InvokeCommandSplat -AsJob
    }
    while (Get-Job -State "Running") {
        $TotalJobs = $Jobs.count
        $NotRunning = $Jobs | Where-Object { $_.State -ne "Running" }
        $Running = $Jobs | Where-Object { $_.State -eq "Running" }
        Write-Progress -Activity "Waiting on results" -Status "$($TotalJobs-$NotRunning.count) Jobs Remaining: $($Running.Location)" -PercentComplete ($NotRunning.count/(0.1+$TotalJobs) * 100)
        Start-Sleep -Seconds 2
    }
    Get-Job | Receive-Job
    Get-Job | Remove-Job
}
