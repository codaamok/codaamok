Function Get-PSTools {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Function Unzip {
        Param(
            [string]$zipfile, 
            [string]$outpath
        )
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    }
    try {
        $Path = (Join-Path -Path $env:LOCALAPPDATA -ChildPath "Microsoft\WindowsApps")
        (New-Object System.Net.WebClient).DownloadFile("https://download.sysinternals.com/files/PSTools.zip", (Join-Path -Path $Path -ChildPath "PSTools.zip"))
        Unzip -zipfile (Join-Path -Path $Path -ChildPath "PSTools.zip") -outpath $Path
        Rename-Item -LiteralPath (Join-Path -Path $Path -ChildPath "PSexec.exe") -NewName (Join-Path -Path $Path -ChildPath "PSexec_.exe") -ErrorAction Stop
    }
    catch {
        Write-Host "Error: " -ForegroundColor Red -NoNewline
        Write-Host $_.Exception.Message -NoNewline
        Write-Host (" (line {0})" -f $_.InvocationInfo.ScriptLineNumber)
    }
}
