function Update-RoyalTSPortable {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$Path = "{0}\RoyalTS" -f [Environment]::GetFolderPath("MyDocuments")
    )

    if (-not (Test-Path $Path)) {
        Write-Warning ("Path '{0}' does not exist" -f $Path)
        $Y = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Create directory and download RoyalTS"
        $N = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not create directory and do not download RoyalTS"
        $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Y, $N)
        $Question = "Would you like to continue?"
        $Message = "Creating directory '{0}'" -f $Path
        $Result = $host.ui.PromptForChoice($Question, $Message, $Options, 1)

        if ($Result -ge 1) {
            return
        }

        New-Item -ItemType "Container" -Path $Path -Force -ErrorAction "Stop"
    }

    $URL = (Invoke-WebRequest -Uri "https://www.royalapps.com/ts/win/download" | Select-Object -ExpandProperty links) -match "\.zip" | Select-Object -ExpandProperty href

    if ($URL) {
        $FileName = ($URL -split "/")[-1]
        $File = ("{0}\{1}" -f $env:temp, $FileName)
        (New-Object System.Net.WebClient).DownloadFile($URL, $File)
    }

    if (Get-Process -Name "RoyalTS" -ErrorAction "SilentlyContinue") {
        Write-Warning "RoyalTS is running"
        $Y = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Stop RoyalTS process"
        $N = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not stop RoyalTS process"
        $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Y, $N)
        $Question = "Would you like to continue?"
        $Message = "Stop RoyalTS process"
        $Result = $host.ui.PromptForChoice($Question, $Message, $Options, 1)

        if ($Result -ge 1) {
            return
        }

        Stop-Process -Name "RoyalTS" -ErrorAction "Stop"
    }

    Expand-Archive -Path $File -DestinationPath $Path -Force

    Remove-Item -Path $File
}
