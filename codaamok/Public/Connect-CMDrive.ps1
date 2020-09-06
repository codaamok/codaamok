Function Connect-CMDrive {
    param(
        # SMS provider or site server
        [Parameter(Mandatory=$false, Position = 0)]
        [ValidateScript({
            If(!(Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue)) {
                throw "Host `"$($_)`" is unreachable"
            } Else {
                return $true
            }
        })]
        [string]
        $Server,
        [Parameter(Mandatory=$false, Position = 1)]
        [string]
        $SiteCode,
        [Parameter(Mandatory=$false, Position = 2)]
        [string]
        $Path = (Get-Location | Select-Object -ExpandProperty Path)
    )
    if ([string]::IsNullOrEmpty($Server)) {
        try {
            $Server = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ConfigMgr10\AdminUI\Connection" -ErrorAction Stop | Select-Object -ExpandProperty Server
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            throw "Console must be installed. If it is installed, then fix your code but for now specify -Server"
        }
    }
    if ([string]::IsNullOrEmpty($SiteCode)) {
        try {
            $SiteCode = Get-WmiObject -Class "SMS_ProviderLocation" -Name "ROOT\SMS" -ComputerName $Server -ErrorAction Stop | Select-Object -ExpandProperty SiteCode
        }
        catch {
            switch -regex ($_.Exception.Message) {
                "Invalid namespace" {
                    throw ("No SMS provider installed on {0}" -f $Server)
                }
                default {
                    throw "Could not determine SiteCode, please pass -SiteCode"
                }
            }
        }
    }

    # Import the ConfigurationManager.psd1 module 
    If((Get-Module ConfigurationManager) -eq $null) {
        try {
            Import-Module ("{0}\..\ConfigurationManager.psd1" -f $ENV:SMS_ADMIN_UI_PATH)
        }
        catch {
            throw ("Failed to import ConfigMgr module: {0}" -f $_.Exception.Message)
        }
    }
    try {
        # Connect to the site's drive if it is not already present
        If((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
            New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $Server -ErrorAction Stop | Out-Null
        }
        # Set the current location to be the site code.
        Set-Location ("{0}:\" -f $SiteCode) -ErrorAction Stop

        # Verify given sitecode
        If((Get-CMSite -SiteCode $SiteCode | Select-Object -ExpandProperty SiteCode) -ne $SiteCode) { throw }

    } 
    catch {
        If((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -ne $null) {
            Set-Location $Path
            Remove-PSDrive -Name $SiteCode -Force
        }
        throw ("Failed to create New-PSDrive with site code `"{0}`" and server `"{1}`"" -f $SiteCode, $Server)
    }
}
