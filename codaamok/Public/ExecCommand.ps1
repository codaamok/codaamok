function ExecCommand([string]$ComputerName, [string]$Command)
    {
        #Pass the entire remote command as a base64 encoded string to powershell.exe
        $commandLine = "powershell.exe -NoLogo -NonInteractive -ExecutionPolicy Unrestricted -WindowStyle Hidden -EncodedCommand " + $Command
        $process = Invoke-WmiMethod -ComputerName $ComputerName -Class Win32_Process -Name Create -ArgumentList $commandLine
        
        if ($process.ReturnValue -eq 0)
        {
            $started = Get-Date
            
            Do
            {
                if ($started.AddMinutes(2) -lt (Get-Date))
                {
                    Write-Host "PID: $($process.ProcessId) - Response took too long."
                    break
                }
                
                # TODO: Add timeout
                $watcher = Get-WmiObject -ComputerName $ComputerName -Class Win32_Process -Filter "ProcessId = $($process.ProcessId)"
                
                Write-Host "PID: $($process.ProcessId) - Waiting for remote command to finish..."
                
                Start-Sleep -Seconds 1
            }
            While ($watcher -ne $null)
            
            # Once the remote process is done, retrieve the output
            $scriptOutput = GetScriptOutput $ComputerName $scriptCommandId
            
            return $scriptOutput
        }
    }
