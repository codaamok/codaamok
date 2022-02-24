Function Invoke-CMClientAction {
    Param( 
        [Parameter()]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter(Mandatory = $true)]
        [ValidateSet('MachinePolicy',
			'DiscoveryData',
			'ComplianceEvaluation',
			'AppDeployment', 
			'HardwareInventory',
			'UpdateDeployment',
			'UpdateScan',
			'SoftwareInventory')]
        [String]$Action
    )
    $ScheduleIDMappings = @{
        'MachinePolicy' = '{00000000-0000-0000-0000-000000000021}'
        'DiscoveryData' = '{00000000-0000-0000-0000-000000000003}'
        'ComplianceEvaluation' = '{00000000-0000-0000-0000-000000000071}'
        'AppDeployment' = '{00000000-0000-0000-0000-000000000121}'
        'HardwareInventory' = '{00000000-0000-0000-0000-000000000001}'
        'UpdateDeployment' = '{00000000-0000-0000-0000-000000000108}'
        'UpdateScan' = '{00000000-0000-0000-0000-000000000113}'
        'SoftwareInventory' = '{00000000-0000-0000-0000-000000000002}'
    }
    $ScheduleID = @{ "sScheduleID" = $ScheduleIDMappings[$Action] }
    $InvokeCommandSplat = @{
        ScriptBlock = {
            Param (
                [Parameter(Mandatory = $true)]
                [hashtable]$ScheduleID
            )
            $Result = @{
                ComputerName = $env:COMPUTERNAME
            }
            Invoke-CimMethod -Namespace "ROOT/CCM" -ClassName "SMS_Client" -MethodName "TriggerSchedule" -Arguments $ScheduleID -ErrorAction "Stop"
            $Result["Result"] = $?
            return [PSCustomObject]$Result
        }
        ArgumentList = $ScheduleID
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
