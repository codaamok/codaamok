function Get-Username {
    param (
        [String]$OS
    )
    if ($OS -eq "Windows") {
        $env:USERNAME
    }
    else {
        $env:USER
    }
}
