function CreateScriptInstance([string]$ComputerName)
    {
        # Check to see if our custom WMI class already exists
        $classCheck = Get-WmiObject -Class Noxigen_WmiExec -ComputerName $ComputerName -List -Namespace "root\cimv2"
        
        if ($classCheck -eq $null)
        {
            # Create a custom WMI class to store data about the command, including the output.
            Write-Host "Creating WMI class..."
            $newClass = New-Object System.Management.ManagementClass("\\$ComputerName\root\cimv2",[string]::Empty,$null)
            $newClass["__CLASS"] = "Noxigen_WmiExec"
            $newClass.Qualifiers.Add("Static",$true)
            $newClass.Properties.Add("CommandId",[System.Management.CimType]::String,$false)
            $newClass.Properties["CommandId"].Qualifiers.Add("Key",$true)
            $newClass.Properties.Add("CommandOutput",[System.Management.CimType]::String,$false)
            $newClass.Put() | Out-Null
        }
        
        # Create a new instance of the custom class so we can reference it locally and remotely using this key
        $wmiInstance = Set-WmiInstance -Class Noxigen_WmiExec -ComputerName $ComputerName
        $wmiInstance.GetType() | Out-Null
        $commandId = ($wmiInstance | Select-Object -Property CommandId -ExpandProperty CommandId)
        $wmiInstance.Dispose()
        
        # Return the GUID for this instance
        return $CommandId
    }
