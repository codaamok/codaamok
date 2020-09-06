function Main()
    {
        $commandString = $Command
        
        # The GUID from our custom WMI class. Used to get only results for this command.
        $scriptCommandId = CreateScriptInstance $ComputerName
        
        if ($scriptCommandId -eq $null)
        {
            Write-Error "Error creating remote instance."
            exit
        }
        
        # Meanwhile, on the remote machine...
        # 1. Execute the command and store the output as a string
        # 2. Get a reference to our current custom WMI class instance and store the output there!
            
        $encodedCommand = "`$result = Invoke-Command -ScriptBlock {$commandString} | Out-String; Get-WmiObject -Class Noxigen_WmiExec -Filter `"CommandId = '$scriptCommandId'`" | Set-WmiInstance -Arguments `@{CommandOutput = `$result} | Out-Null"
        
        $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($encodedCommand))
        
        Write-Host "Running the below command on: $ComputerName..."
        Write-Host $commandString
        
        $result = ExecCommand $ComputerName $encodedCommand
        
        Write-Host "Result..."
        Write-Output $result
    }
