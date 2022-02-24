function Read-Log {
    param (
        [Parameter(Mandatory = $true)][ValidateSet ('Success', 'Fail')][string]$status
    )        

    Switch ($status) {
        'Success' { $Pattern = 'Win32 Code 0'; $Regex = '\<\!\[LOG.*\((?<Message>\w+|.*)\).*\]LOG]\!\>\<time=\"(?<Time>.{12}).*date=\"(?<Date>.{10})' }
        'Fail' { $Pattern = 'Failed to run the action'; $Regex = '.*:\s(?<Message>.*|.*\n.*)\]\w+\].{3}time\S{2}(?<Time>.{12}).*date\S{2}(?<Date>.{10})' }
    }

    Get-Content $file | Select-String -Pattern $Pattern -Context 1| ForEach-Object {
        $_ -match $Regex | Out-Null

        [PSCustomObject]@{
            Computer = $Computer
            Time     = [datetime]::ParseExact($("$($matches.date) $($matches.time)"), "MM-dd-yyyy HH:mm:ss.fff", $null)
            Message  = $Matches.Message
            File     = $File
        }
    } | Format-Table -AutoSize
}
