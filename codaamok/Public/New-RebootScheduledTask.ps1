Function New-RebootScheduledTask {
    Param(
        [Parameter()]
        [String]$ComputerName,
        [Parameter(Mandatory)]
        [Datetime]$UTCTime,
        [Parameter(Mandatory)]
        [String]$Description,
        [Parameter()]
        [String]$TaskName = "Itergy - Reboot",
        [Parameter()]
        [String]$TaskPath = "\",
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$Force
    )

    $GetScheduledTaskSplat = @{
        TaskName = $TaskName
        TaskPath = $TaskPath
        ErrorAction = "SilentlyContinue"
    }

    $GetCimInstanceSplat = @{
        ErrorAction = "Stop"
    }

    if ($PSBoundParameters.ContainsKey("ComputerName")) {
        $NewCimSession = @{
            ComputerName = $ComputerName
            ErrorAction = "Stop"
        }
        if ($PSBoundParameters.ContainsKey("Credential")) {
            $NewCimSession["Credential"] = $Credential
        }
        $Session = New-CimSession @NewCimSession
        $GetCimInstanceSplat["CimSession"] = $Session
        $GetScheduledTaskSplat["CimSession"] = $Session
    }

    if (Get-ScheduledTask @GetScheduledTaskSplat) {
        if ($Force.IsPresent) {
            $UnregisterScheduledTaskSplat = @{
                TaskName = $TaskName
                TaskPath = $TaskPath
                Confirm = $false
                ErrorAction = "Stop"
            } 
            if ($PSBoundParameters.ContainsKey("ComputerName")) {
                $UnregisterScheduledTaskSplat["CimSession"] = $Session
            }
            Unregister-ScheduledTask @UnregisterScheduledTaskSplat
        }
        else {
            Write-Warning "Scheduled task already exists, use -Force to recreate"
            return
        }
    }

    try {
        $TimeZone = Get-CimInstance -ClassName "Win32_TimeZone" @GetCimInstanceSplat
    }
    catch {
        Write-Warning "Could not determine target system's timezone"
    }

    try {
        $LocalTime = Get-CimInstance -ClassName "Win32_LocalTime" @GetCimInstanceSplat
        $LocalTime = Get-Date -Year $LocalTime.year -Month $LocalTime.month -day $LocalTime.day -Hour $LocalTime.hour -Minute $LocalTime.minute -Second $LocalTime.Second
    }
    catch {
        Write-Warning "Could not detemrine target system's local time"
    }

    $Y = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Continue with lab build"
    $N = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not continue with lab build"
    $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Y, $N)
    $Message = "Target machine's timezone is '{0}' ('{1}'), would you like to continue with '{2} UTC?'" -f $TimeZone.Caption, $LocalTime, $UTCTime.ToUniversalTime()
    $Result = $host.ui.PromptForChoice($null, $Message, $Options, 1)

    if ($Result -ge 1) {
        return
    }

    $Description = "{0} - created by {1} on {2} (UTC)" -f $Description, $env:USERNAME, $UTCTime.ToUniversalTime()

    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NonInteractive -NoLogo -NoProfile -Command "Restart-Computer -Force"'
    $Trigger = New-ScheduledTaskTrigger -Once -At $UTCTime.ToUniversalTime()
    $Settings = New-ScheduledTaskSettingsSet
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings -Description $Description
    Register-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -InputObject $Task -User "System" -CimSession $Session

    if ($Session) { Remove-CimSession -CimSession $Session }
}
