Function Start-SetupDiag {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Alias('Computer', 'PSComputerName', 'Name', 'HostName')]
        [String[]]$ComputerName,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )

    $InvokeCommandSplat = @{
        ComputerName    = $ComputerName
        ScriptBlock     = {
            New-Item -ItemType Directory -Path $env:SystemDrive\SetupDiag
            Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=870142" -OutFile $env:SystemDrive\SetupDiag\SetupDiag.exe
            $path = "{0}\SetupDiag" -f $env:SystemDrive; Start-Process -FilePath $path\SetupDiag.exe -ArgumentList @("/Output:$path\Results.log") -Wait
            $path = "{0}\SetupDiag" -f $env:SystemDrive; Get-Content -Path $path\results.log
        }
    }

    if ($PSBoundParameters.ContainsKey('Credential')) {
        $InvokeCommandSplat.Add('Credential', $Credential)
    }

    Invoke-Command @InvokeCommandSplat
}
