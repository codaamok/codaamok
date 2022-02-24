Function Remove-WUWSUSRegKeys {
    [CmdletBinding()]
    Param( 
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('PSComputerName')]
        [String[]]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential
    )
    Begin {
        [System.Collections.Generic.List[Object]]$Jobs = @{}
    }
    Process {
        $InvokeCommandSplat = @{
            ScriptBlock = {
                $Result = [Ordered]@{}
                if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate") -ne $true) {
                    throw "WindowsUpdate registry key does not exist"
                }
                if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU") -ne $true) {
                    throw "WindowsUpdate registry key does not exist"
                }
                Remove-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUServer" -ErrorAction "SilentlyContinue"
                $Result["WUServer"] = $?
                Remove-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUStatusServer" -ErrorAction "SilentlyContinue"
                $Result["WUStatusServer"] = $?
                New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 0 -PropertyType "DWord" -Force -ErrorAction "SilentlyContinue"| Out-Null
                $Result["UseWUServer"] = $?
                Get-Service -Name "wuauserv" | Restart-Service -Force -ErrorAction "SilentlyContinue"
                $Result["RestartWU"] = $?
                $Result["ComputerName"] = $env:COMPUTERNAME
                [PSCustomObject]$Result
            }
            ComputerName = $ComputerName
        }
        if ($PSBoundParameters.ContainsKey("Credential")) {
            $InvokeCommandSplat["Credential"] = $Credential
        }
        $Jobs.Add((Invoke-Command @InvokeCommandSplat -AsJob))
    }
    End {
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
}
