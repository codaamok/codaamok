Function Get-Reboots {
    Param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )
    $HashArguments = @{
        FilterHashtable = @{
            LogName="System"
            ID=1074
        }
    } 
    if ($PSBoundParameters.ContainsKey("ComputerName")) {
        $HashArguments.Add("ComputerName", $ComputerName)
    }
    else {
        $HashArguments.Add("ComputerName", $env:COMPUTERNAME)
    }
    Get-WinEvent @HashArguments | ForEach-Object {
        [PSCustomObject]@{
            Date = $_.TimeCreated
            User = $_.Properties[6].Value
            Process = $_.Properties[0].Value
            Action = $_.Properties[4].Value
            Reason = $_.Properties[2].Value
            ReasonCode = $_.Properties[3].Value
            Comment = $_.Properties[5].Value
        }
    } | Sort-Object Date -Descending
}
