Function Shamefully-ResetBITS {
    Param( 
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential
    )
    $InvokeCommandSplat = @{
        ScriptBlock = {
            $Result = @{
                ComputerName = $env:COMPUTERNAME
            }
            try {
                Get-Service -Name "bits" -ErrorAction "Stop" | Stop-Service -Force -ErrorAction "Stop" -WarningAction "SilentlyContinue"
                Start-Process "ipconfig" -ArgumentList "/flushdns" -ErrorAction "Stop"
                $path = "{0}\Microsoft\Network\Downloader" -f $env:ProgramData
                Get-ChildItem -Path $path | ForEach-Object {
                    if ($_.FullName -notmatch "\.log$|\.old$") {
                        Move-Item -LiteralPath $_.FullName -Destination ($_.FullName + ".old") -Force -ErrorAction "Stop"
                    }
                }
                Get-Service -Name "bits" -ErrorAction "Stop" | Start-Service -ErrorAction "Stop"
                $Result["Result"] = "Success"
            }
            catch {
                $Result["Result"] = $error[0].Exception.Message
            }
            [PSCustomObject]$Result
        }
    }
    if ($PSBoundParameters.ContainsKey("Credential")) {
        $InvokeCommandSplat["Credential"] = $Credential
    }
    $Jobs = ForEach ($Computer in $ComputerName) {
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
    Receive-Job -Job $Jobs
    Remove-Job -Job $Jobs   
}
