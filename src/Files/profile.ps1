function Update-Profile {
    param (
        [Switch]$AsJob
    )

    $ScriptBlock = {
        $Module = Import-Module codaamok -PassThru -ErrorAction "Stop"
        Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $using:profile.CurrentUserAllHosts -Force -ErrorAction "Stop"
        Copy-Item -Path "$($Module.ModuleBase)\*.omp.json" -Destination $HOME -Force -ErrorAction "Stop"
    }

    if ($AsJob) {
        $null = Start-Job -ScriptBlock $ScriptBlock -Name "UpdateProfile"
    }
    else {
        & $ScriptBlock
        '. $profile.CurrentUserAllHosts' | Set-ClipBoard
        Write-Host "Paste your clipboard"
    }
}

function Update-ProfileModule {
    param (
        [Switch]$AsJob
    )

    $ScriptBlock = {
        $Installed = Get-Module -Name "codaamok" -ListAvailable -ErrorAction "Stop"
        $Available = Find-Module -Name "codaamok" -ErrorAction "Stop"

        if ($Installed[0].Version -ne $Available.Version) {
            Update-Module -Name "codaamok" -Force -ErrorAction "Stop"
        }
    }

    if ($AsJob) {
        $null = Start-Job -ScriptBlock $ScriptBlock -Name "UpdateProfileModule"
    }
    else {
        & $ScriptBlock
    }
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
                $IsMacOS {
                    "MacOS"
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
    Update-ProfileModule -AsJob
}

Update-Profile -AsJob

if ((Get-Module "PSReadline" -ListAvailable).Version -ge [System.Version]"2.2.0") {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}
else {
    "Missing PSReadline 2.2.0 or newer, will not set options"
}

$script:MyOS = Get-MyOS
$script:MyUsername = Get-Username -OS $script:MyOS
$script:MachineProfile = "{0}\profile-machine.ps1" -f $HOME
$script:WorkApps = @(
    "Front"
    "Teams"
    "tidio"
    "outlook"
)

if (Test-Path $script:MachineProfile) {
    . $script:MachineProfile
}

if (Get-Command "oh-my-posh") {
    $OMPThemeJson = Join-Path -Path $HOME -ChildPath 'theme.omp.json'
    if (Test-Path $OMPThemeJson) {
        oh-my-posh prompt init pwsh --config $OMPThemeJson | Invoke-Expression
    }
    else {
        "Did not find 'theme.omp.json' in home directory"
    }
}
else {
    "oh-my-posh is not installed"
}

Set-Alias -Name "ctj" -Value "ConvertTo-Json"
