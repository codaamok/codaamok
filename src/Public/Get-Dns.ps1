Function Get-Dns {
    Param( 
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter(Mandatory)]
        [String]$FirstOctet,
        [Parameter()]
        [PSCredential]$Credential
    )
    $InvokeCommandSplat = @{
        ScriptBlock = {
            $InterfaceIndex = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress.StartsWith($FirstOctet) } | Select-Object -ExpandProperty InterfaceIndex
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                DNSAddresses = [String]::Join(", ", (Get-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -AddressFamily IPv4).ServerAddresses)
            }
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
    Get-Job | Receive-Job
    Get-Job | Remove-Job    
}
