Function New-ModuleDirStructure {
    <#
    .NOTES
        http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
    #>
    Param (
        [Parameter(Mandatory)]
        [String]$Path,
        [Parameter(Mandatory)]
        [String]$ModuleName,
        [Parameter(Mandatory)]
        [String]$Author,
        [Parameter(Mandatory)]
        [String]$Description,
        [Parameter()]
        [String]$PowerShellVersion = 5.1
    )

    # Create the module and private function directories
    New-Item -Path $Path\$ModuleName -ItemType Directory -Force
    New-Item -Path $Path\$ModuleName\Private -ItemType Directory -Force
    New-Item -Path $Path\$ModuleName\Public -ItemType Directory -Force
    New-Item -Path $Path\$ModuleName\en-US -ItemType Directory -Force # For about_Help files
    #New-Item -Path $Path\Tests -ItemType Directory -Force

    #Create the module and related files
    New-Item "$Path\$ModuleName\$ModuleName.psm1" -ItemType File -Force
    #New-Item "$Path\$ModuleName\$ModuleName.Format.ps1xml" -ItemType File -Force
    New-Item "$Path\$ModuleName\en-US\about_$ModuleName.help.txt" -ItemType File -Force
    #New-Item "$Path\Tests\$ModuleName.Tests.ps1" -ItemType File -Force
    $NewModuleManifestSplat = @{
        Path                = Join-Path -Path $Path -ChildPath $ModuleName | Join-Path -ChildPath "$ModuleName.psd1"
        RootModule          = $ModuleName.psm1
        Description         = $Description
        PowerShellVersion   = $PowerShellVersion
        Author              = $Author
        # FormatsToProcess    = "$ModuleName.Format.ps1xml"
    }
    New-ModuleManifest @NewModuleManifestSplat

    # Copy the public/exported functions into the public folder, private functions into private folder
}
