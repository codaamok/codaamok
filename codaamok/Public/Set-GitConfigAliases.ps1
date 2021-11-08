function Set-GitConfigAliases {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$gitconfig = "{0}\.gitconfig" -f $HOME
    )

    $content = [ordered]@{
        "title" = "alias"
        "pu"    = "push"
        "lo"    = "log --abbrev-commit --graph --oneline"
        "me"    = "merge --no-ff"
        "st"    = "status -sb"
        "co"    = "commit -m"
        "ch"    = "checkout"
        "chb"   = "checkout -b"
        "del"   = "branch -D"
    }

    ConvertTo-Ini -Content $content -SectionTitleKeyName "title" | Add-Content -Path $gitconfig -Force
}
