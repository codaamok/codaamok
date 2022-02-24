Function Get-MyCommands {
    [Alias("Get-MyFunctions")]
    param (
        [String]$ProfileFile = $PSCommandPath
    )

    Get-Content -Path $ProfileFile | Select-String -Pattern "^function.+" | ForEach-Object {
        $result = [Regex]::Matches($_, "^function ([a-z.-]+)","IgnoreCase").Groups[1].Value
        if ($result -ne "prompt") { $result }
    } | Sort-Object
}
