function prompt {
    # .Description
    # This custom version of the PowerShell prompt will present a colorized location value based on the current provider. It will also display the PS prefix in red if the current user is running as administrator.    
    # .Link
    # https://go.microsoft.com/fwlink/?LinkID=225750
    # .ExternalHelp System.Management.Automation.dll-help.xml

    $adminfg = switch ($script:MyOS) {
        "Windows" {
            $user = [Security.Principal.WindowsIdentity]::GetCurrent()
            switch ((New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
                $true {
                    "Red"
                }
                $false {
                    "White"
                }
            }
        }
        default {
            "White"
        }
    }

    switch ((Get-Location).Provider.Name) {
        "FileSystem"    { $fg = "green"}
        "Registry"      { $fg = "magenta"}
        "wsman"         { $fg = "cyan"}
        "Environment"   { $fg = "yellow"}
        "Certificate"   { $fg = "darkcyan"}
        "Function"      { $fg = "gray"}
        "alias"         { $fg = "darkgray"}
        "variable"      { $fg = "darkgreen"}
        default         { $fg = $host.ui.rawui.ForegroundColor}
    }

    Write-Host ("[{0}@{1}] " -f $global:MyUsername, [System.Net.Dns]::GetHostName()) -NoNewline
    Write-Host ("[{0}]" -f (Get-Date -Format "HH:mm:ss")) -NoNewline
    Write-Host " PS " -NoNewline -ForegroundColor $adminfg
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor $fg
    Write-Output ("{0} " -f (">" * ($nestedPromptLevel + 1)))
}

function Update-Profile {
    $Module = Import-Module codaamok -PassThru -ErrorAction "Stop"
    Copy-Item -Path "$($Module.ModuleBase)\profile.ps1" -Destination $profile.CurrentUserAllHosts -Confirm -ErrorAction "Stop"
    '. $profile.CurrentUserAllHosts' | clip
    Write-Host "Paste your clipboard"
}

function Update-ProfileModule {
    $ScriptBlock = {
        $Installed = Get-Module -Name "codaamok" -ListAvailable -ErrorAction "Stop"
        $Available = Find-Module -Name "codaamok" -ErrorAction "Stop"

        if ($Installed[0].Version -ne $Available.Version) {
            Update-Module -Name "codaamok" -ErrorAction "Stop"
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

# Do not use OneDrive\Documents folder for PSModulePath

$env:PSModulePath = ($env:PSModulePath -split ';' | ForEach-Object {
    if ($_ -notmatch 'OneDrive') { $_ }
    else { 
        $_ -replace [Regex]::Escape($_), $(
            if ($PSVersionTable.PSVersion -ge [System.Version]"7.0") {
                if ($IsLinux) { "{0}/.local/share/powershell/Modules" -f $home }
                else { "{0}\Documents\PowerShell\Modules\" -f $home }
            }
            else {
                "{0}\Documents\WindowsPowerShell\Modules\" -f $home
            }
        )
    }
}) -join ';'

if (-not (Get-Module "codaamok" -ListAvailable)) {
    $answer = Read-Host -Prompt "Profile module not installed, install? (Y)"
    if ($answer -eq "Y" -or $answer -eq "") {
        Install-Module -Name "codaamok" -Scope "CurrentUser" -ErrorAction "Continue"
    }
}
else {
    Update-ProfileModule
}

if ($PSVersionTable.PSVersion -ge [System.Version]"7.0") {
    if ((Get-Module "PSReadline" -ListAvailable).Version -ge [System.Version]"2.2.0") {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
    else {
        "Missing PSReadline 2.2.0 or newer, will not set options"
    }
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

Set-Alias -Name "ctj" -Value "ConvertTo-Json"
