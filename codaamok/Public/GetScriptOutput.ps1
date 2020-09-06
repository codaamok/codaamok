function GetScriptOutput([string]$ComputerName, [string]$CommandId)
    {
        $wmiInstance = Get-WmiObject -Class Noxigen_WmiExec -ComputerName $ComputerName -Filter "CommandId = '$CommandId'"
        $result = ($wmiInstance | Select-Object CommandOutput -ExpandProperty CommandOutput)
        $wmiInstance | Remove-WmiObject
        return $result
    }
