Function Upload-Profile {
    <#
    .NOTES
    https://winscp.net/eng/docs/library_powershell
    #>
    Param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]$user,
        [Parameter(Mandatory=$true,Position=1)]
        [string]$pass
    )

    switch ($true) {
        ((Test-Path -LiteralPath ("{0}\WinSCPnet.dll" -f ${env:ProgramFiles(x86)})) -And (Test-Path -LiteralPath ("{0}\WinSCP.exe" -f ${env:ProgramFiles(x86)}))) {
            $dllPath = ("{0}\WinSCPnet.dll" -f ${env:ProgramFiles(x86)})
            break
        }
        ((Test-Path -LiteralPath ("{0}\WinSCPnet.dll" -f $env:ProgramFiles)) -And (Test-Path -LiteralPath ("{0}\WinSCP.exe" -f $env:ProgramFiles))) {
            # Unlikely as WinSCP only 32bit and I don't think I ever touch 32bit systems
            $dllPath = ("{0}\WinSCPnet.dll" -f $env:ProgramFiles)
            break
        }
        ((Test-Path -LiteralPath ("{0}\WinSCP\WinSCPnet.dll" -f [System.Environment]::GetFolderPath("MyDocuments"))) -And (Test-Path -LiteralPath ("{0}\WinSCP\WinSCP.exe" -f [System.Environment]::GetFolderPath("MyDocuments")))) {
            $dllPath = ("{0}\WinSCP\WinSCPnet.dll" -f [System.Environment]::GetFolderPath("MyDocuments"))
            break
        }
        default {
            try {
                New-Item -Path ("{0}\WinSCP" -f [System.Environment]::GetFolderPath("MyDocuments")) -ItemType Directory -Force -ErrorAction Stop
                $zipPath = ("{0}\WinSCP\WinSCP-5.15.3-Automation.zip" -f [System.Environment]::GetFolderPath("MyDocuments"))
                $zipHash = "6FC1B65724665EF094B2CBFE3F2F8F996BAE627A4569F2C25867C98695ACD288"
                Invoke-WebRequest -Uri "https://www.cookadam.co.uk/scripts/WinSCP-5.15.3-Automation.zip" -OutFile $zipPath -ErrorAction Stop
                switch(Get-FileHash -LiteralPath $zipPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash) {
                    $zipHash {
                        Add-Type -AssemblyName System.IO.Compression.FileSystem
                        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, (Split-Path -Path $zipPath))
                        $dllPath = ("{0}\WinSCP\WinSCPnet.dll" -f [System.Environment]::GetFolderPath("MyDocuments"))
                    }
                    default {
                        Throw "Hash mismatch from download"
                    }
                }
            }
            catch {
                Write-Host "Error: " -ForegroundColor Red -NoNewline
                Write-Host $Error[0].Exception.Message
                $problem = $true
            }
        }
    }

    $hostname = "ftp.cookadam.co.uk"
    $dir = "public_html/scripts/"
    switch ($problem) {
        $true {
            $Title = "Won't be able to upload using SFTP, proceed with FTP?"
            $y = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Proceed to upload via FTP"
            $n = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Abort upload"
            $options = [System.Management.Automation.Host.ChoiceDescription[]]($y,$n)
            $UseFTP = $host.ui.PromptForChoice($title, $null, $options, 1)
            switch ($UseFTP) {
                1 {
                    Write-Host "Aborting"
                    return
                }
                default {
                    try {
                        $ftp = ("ftp://{0}/{1}" -f $hostname, $dir)
                        $webclient = New-Object System.Net.WebClient 
                        $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)
                        $uri = New-Object -TypeName System.Uri -ArgumentList ($ftp+(Split-Path $profile.CurrentUserAllHosts -Leaf))
                        $webclient.UploadFile($uri, $profile.CurrentUserAllHosts)
                    }
                    catch {
                        Write-Host "Error: " -ForegroundColor Red -NoNewline
                        Write-Host $Error[0].Exception.Message
                    }
                }
            }
        }
        default {
            try {
                # Load WinSCP .NET assembly
                Add-Type -Path $dllPath
            
                # Setup session options
                $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
                    Protocol = [WinSCP.Protocol]::Sftp
                    HostName = $hostname
                    UserName = $user
                    Password = $pass
                    PortNumber = 722
                    SshHostKeyFingerprint = "ssh-ed25519 256 qzr6Ci1g8gxABaGNVI76RYRfPiVMX14a+1f4a7dxczU="
                }
            
                $session = New-Object WinSCP.Session
            
                try {
                    # Connect
                    $session.Open($sessionOptions)
            
                    # Upload files
                    $transferOptions = New-Object WinSCP.TransferOptions
                    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
            
                    $transferResult = $session.PutFiles($profile.CurrentUserAllHosts, $dir, $false, $transferOptions)
            
                    # Throw on any error
                    $transferResult.Check()
            
                    # Print results
                    foreach ($transfer in $transferResult.Transfers)
                    {
                        Write-Host "Success: " -ForegroundColor Green -NoNewline
                        Write-Host ("Upload of {0} [ OK ]" -f $transfer.FileName)
                    }
                }
                finally {
                    # Disconnect, clean up
                    $session.Dispose()
                }
            }
            catch {
                Write-Host "Error: " -ForegroundColor Red -NoNewline
                Write-Host $Error[0].Exception.Message
            }
        }
    }
}
