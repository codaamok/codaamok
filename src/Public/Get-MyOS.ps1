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
