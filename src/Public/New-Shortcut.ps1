Function New-Shortcut {
        Param(
            [Parameter(Mandatory=$true)]
            [string]$Target,
            [Parameter(Mandatory=$false)]
            [string]$TargetArguments,
            [Parameter(Mandatory=$true)]
            [string]$ShortcutName
        )
        $Path = Join-Path -Path ([System.Environment]::GetFolderPath("Desktop")) -ChildPath $ShortcutName
        switch ($ShortcutName.EndsWith(".lnk")) {
            $false {
                $ShortcutName = $ShortcutName + ".lnk"
            }
        }
        switch (Test-Path -LiteralPath $Path) {
            $true {
                Write-Warning ("Shortcut already exists: {0}" -f (Split-Path $Path -Leaf))
            }
            $false {
                $WshShell = New-Object -comObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut($Path)
                $Shortcut.TargetPath = $Target
                If ($null -ne $TargetArguments) {
                    $Shortcut.Arguments = $TargetArguments
                }
                $Shortcut.Save()
            }
        }
    }
