Function Add-FileAssociation {
        <#
        .SYNOPSIS
        Set user file associations
        .DESCRIPTION
        Define a program to open a file extension
        .PARAMETER Extension
        The file extension to modify
        .PARAMETER TargetExecutable
        The program to use to open the file extension
        .PARAMETER ftypeName
        Non mandatory parameter used to override the created file type handler value
        .EXAMPLE
        $HT = @{
            Extension = '.txt'
            TargetExecutable = "C:\Program Files\Notepad++\notepad++.exe"
        }
        Add-FileAssociation @HT
        .EXAMPLE
        $HT = @{
            Extension = '.xml'
            TargetExecutable = "C:\Program Files\Microsoft VS Code\Code.exe"
            FtypeName = 'vscode'
        }
        Add-FileAssociation @HT
        .NOTES
        Found here: https://gist.github.com/p0w3rsh3ll/c64d365d15f6f39116dba1a26981dc68#file-add-fileassociation-ps1 https://p0w3rsh3ll.wordpress.com/2018/11/08/about-file-associations/
        #>
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [ValidatePattern('^\.[a-zA-Z0-9]{1,3}')]
            $Extension,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({
                Test-Path -Path $_ -PathType Leaf
            })]
            [string]$TargetExecutable,
            [string]$ftypeName
        )
        Begin {
            $ext = [Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($Extension)
            $exec = [Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($TargetExecutable)
        
            # 2. Create a ftype
            if (-not($PSBoundParameters['ftypeName'])) {
                $ftypeName = '{0}{1}File'-f $($ext -replace '\.',''),
                $((Get-Item -Path "$($exec)").BaseName)
                $ftypeName = [Management.Automation.Language.CodeGeneration]::EscapeFormatStringContent($ftypeName)
            } else {
                $ftypeName = [Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($ftypeName)
            }
            Write-Verbose -Message "Ftype name set to $($ftypeName)"
        }
        Process {
            # 1. remove anti-tampering protection if required
            if (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$($ext)") {
                $ParentACL = Get-Acl -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$($ext)"
                if (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$($ext)\UserChoice") {
                    $k = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$($ext)\UserChoice",'ReadWriteSubTree','TakeOwnership')
                    $acl  = $k.GetAccessControl()
                    $null = $acl.SetAccessRuleProtection($false,$true)
                    $rule = New-Object System.Security.AccessControl.RegistryAccessRule ($ParentACL.Owner,'FullControl','Allow')
                    $null = $acl.SetAccessRule($rule)
                    $rule = New-Object System.Security.AccessControl.RegistryAccessRule ($ParentACL.Owner,'SetValue','Deny')
                    $null = $acl.RemoveAccessRule($rule)
                    $null = $k.SetAccessControl($acl)
                    Write-Verbose -Message 'Removed anti-tampering protection'
                }
            }
            # 2. add a ftype
            $null = & (Get-Command "$($env:systemroot)\system32\reg.exe") @(
                'add',
                "HKCU\Software\Classes\$($ftypeName)\shell\open\command"
                '/ve','/d',"$('\"{0}\" \"%1\"'-f $($exec))",
                '/f','/reg:64'
            )
            Write-Verbose -Message "Adding command under HKCU\Software\Classes\$($ftypeName)\shell\open\command"
            # 3. Update user file association

            # Reg2CI (c) 2019 by Roger Zander
            $eap = "SilentlyContinue"
            Remove-Item -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithList" -f $ext) -Force
            if((Test-Path -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithList" -f $ext)) -ne $true) { 
                New-Item ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithList" -f $ext) -Force -ErrorAction $eap | Out-Null
            }
            Remove-Item -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithProgids" -f $ext) -Force
            if((Test-Path -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithProgids" -f $ext)) -ne $true) { 
                New-Item ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithProgids" -f $ext) -Force -ErrorAction $eap | Out-Null
            }
            if((Test-Path -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\UserChoice" -f $ext)) -ne $true) {
                New-Item ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\UserChoice" -f $ext) -Force -ErrorAction $eap | Out-Null
            }
            New-ItemProperty -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithList" -f $ext) -Name "MRUList" -Value "a" -PropertyType String -Force -ErrorAction $eap | Out-Null
            New-ItemProperty -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithList" -f $ext) -Name "a" -Value ("{0}" -f (Get-Item -Path $exec | Select-Object -ExpandProperty Name)) -PropertyType String -Force -ErrorAction $eap | Out-Null
            New-ItemProperty -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\OpenWithProgids" -f $ext) -Name $ftypeName -Value (New-Object Byte[] 0) -PropertyType None -Force -ErrorAction $eap | Out-Null
            Remove-ItemProperty -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\UserChoice" -f $ext) -Name "Hash" -Force -ErrorAction $eap
            Remove-ItemProperty -LiteralPath ("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{0}\UserChoice" -f $ext) -Name "Progid" -Force  -ErrorAction $eap
        }
    }
