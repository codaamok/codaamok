function Set-GitConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$WorkEmail,
        [Parameter(Mandatory)]
        [String]$PersonalEmail,
        [Parameter()]
        [String]$gitconfig = "{0}\.gitconfig" -f $HOME,
        [Parameter()]
        [String]$gitconfigwork = "{0}\.gitconfig-work" -f $HOME,
        [Parameter()]
        [String]$gitconfigpersonal = "{0}\.gitconfig-personal" -f $HOME
    )

    $content = @(
        [ordered]@{
            "title" = "includeIf `"gitdir/i:C:/gitpersonal/`""
            "path" = Split-Path $gitconfigpersonal -Leaf
        },
        [ordered]@{
            "title" = "includeIf `"gitdir/i:C:/gitwork/`""       
            "path" = Split-Path $gitconfigwork -Leaf
        }
    )

    ConvertTo-Ini -Content $content -SectionTitleKeyName "title" | Add-Content -Path $gitconfig -Force

    $content = [ordered]@{
        "title" = "user"
        "name" = "Adam Cook"
        "email" = $WorkEmail
    }

    ConvertTo-Ini -Content $content -SectionTitleKeyName "title" | Set-Content -Path $gitconfigwork -Force
    
    $content = [ordered]@{
        "title" = "user"
        "name" = "codaamok"
        "email" = $PersonalEmail
    }

    ConvertTo-Ini -Content $content -SectionTitleKeyName "title" | Set-Content -Path $gitconfigpersonal -Force
}
