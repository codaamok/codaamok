function Get-WUCOMHistory {
    Param(
        [Parameter()]
        [String]$ComputerName,
        [Parameter()]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$ExcludeAV
    )
    switch ($ExcludeAV.IsPresent) {
        $true {
            $ScriptBlock = {
                $Session = New-Object -ComObject Microsoft.Update.Session
                $Searcher = $Session.CreateUpdateSearcher()
                $HistoryCount = $Searcher.GetTotalHistoryCount()
                $Searcher.QueryHistory(0, $HistoryCount) | Where-Object { $_.Title -notmatch "Definition Update" -And $_.Title -notmatch "Antivirus" }
            }
        }
        $false {
            $ScriptBlock = {
                $Session = New-Object -ComObject Microsoft.Update.Session
                $Searcher = $Session.CreateUpdateSearcher()
                $HistoryCount = $Searcher.GetTotalHistoryCount()
                $Searcher.QueryHistory(0, $HistoryCount)
            }
        }
    }
    $InvokeCommandSplat = @{
        ScriptBlock = $ScriptBlock
    }
    if ($PSBoundParameters.ContainsKey("ComputerName")) {
        $InvokeCommandSplat.Add("ComputerName", $ComputerName)
    }
    if ($PSBoundParameters.ContainsKey("Credential")) {
        $InvokeCommandSplat.Add("Credential", $Credential)
    }
    Invoke-Command @InvokeCommandSplat
}
