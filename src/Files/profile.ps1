function Update-Profile {
    $Module = Import-Module codaamok -PassThru -ErrorAction "Stop"
    Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $profile.CurrentUserAllHosts -Force -ErrorAction "Stop"
    $OhMyPoshTheme = Copy-Item -Path "$($Module.ModuleBase)\M365Princess.omp.json" -Destination $HOME -Force -PassThru -ErrorAction "Stop"
    $profile | Add-Member -MemberType "NoteProperty" -Name "OhMyPoshTheme" -Value $OhMyPoshTheme.FullName
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}

function Update-ProfileModule {
    $ScriptBlock = {
        $Installed = Get-Module -Name "codaamok" -ListAvailable -ErrorAction "Stop"
        $Available = Find-Module -Name "codaamok" -ErrorAction "Stop"

        if ($Installed[0].Version -ne $Available.Version) {
            $Module = Update-Module -Name "codaamok" -Force -PassThru -ErrorAction "Stop"
            Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $profile.CurrentUserAllHosts -Force -ErrorAction "Stop"
            Copy-Item -Path "$($Module.ModuleBase)\M365Princess.omp.json" -Destination $HOME -Force -ErrorAction "Stop"
        }
    }

    $null = Start-Job -ScriptBlock $ScriptBlock -Name "UpdateProfileModule"
}

function Search-History {
    [Alias("search")]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$String
    )
    Get-Content (Get-PSReadlineOption).HistorySavePath | Where-Object { $_ -like ("*{0}*" -f $string) -and $_ -notmatch "^search" } | Select-Object -Unique
}

function Get-MyOS {
    switch -Regex ($PSVersionTable.PSVersion) {
        "^[6-7]" {
            switch ($true) {
                $IsLinux {
                    "Linux"
                }
                $IsWindows {
                    "Windows"
                }
            }
        }
        "^[1-5]" {
            "Windows"
        }
    }
}

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

if (-not (Get-Module "codaamok" -ListAvailable)) {
    $answer = Read-Host -Prompt "Profile module not installed, install? (Y)"
    if ($answer -eq "Y" -or $answer -eq "") {
        Install-Module -Name "codaamok" -Scope "CurrentUser" -ErrorAction "Continue"
    }
}
else {
    $Module = Import-Module codaamok -PassThru -ErrorAction "Stop"
    oh-my-posh prompt init pwsh --config 'C:\Users\AdamCook\M365Princess.omp.json' | Invoke-Expression
    Update-ProfileModule
}

if ((Get-Module "PSReadline" -ListAvailable).Version -ge [System.Version]"2.2.0") {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}
else {
    "Missing PSReadline 2.2.0 or newer, will not set options"
}

$script:MyOS = Get-MyOS
$script:MyUsername = Get-Username -OS $script:MyOS
$script:mydocs = [Environment]::GetFolderPath("MyDocuments")
$script:machineprofile = "{0}\profile-machine.ps1" -f $script:mydocs
$script:WorkApps = @(
    "Front"
    "Teams"
    "tidio"
    "outlook"
)

if (Test-Path $script:machineprofile) {
    . $script:machineprofile
}

if (Get-Command "oh-my-posh") {
    oh-my-posh prompt init pwsh --config $profile.OhMyPoshTheme | Invoke-Expression
}
else {
    "oh-my-posh is not installed"
}

Set-Alias -Name "ctj" -Value "ConvertTo-Json"
