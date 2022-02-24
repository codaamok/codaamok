function ConvertTo-Ini {
    param (
        [Object[]]$Content,
        [String]$SectionTitleKeyName
    )
    begin {
        $StringBuilder = [System.Text.StringBuilder]::new()
        $SectionCounter = 0
    }
    process {
        foreach ($ht in $Content) {
            $SectionCounter++

            if ($ht -is [System.Collections.Specialized.OrderedDictionary] -Or $ht -is [hashtable]) {
                if ($ht.Keys -contains $SectionTitleKeyName) {
                    $null = $StringBuilder.AppendFormat("[{0}]", $ht[$SectionTitleKeyName])
                }
                else {
                    $null = $StringBuilder.AppendFormat("[Section {0}]", $SectionCounter)
                }

                $null = $StringBuilder.AppendLine()

                foreach ($key in $ht.Keys) {
                    if ($key -ne $SectionTitleKeyName) {
                        $null = $StringBuilder.AppendFormat("{0}={1}", $key, $ht[$key])
                        $null = $StringBuilder.AppendLine()
                    }
                }

                $null = $StringBuilder.AppendLine()
            }
        }
    }
    end {
        $StringBuilder.ToString(0, $StringBuilder.Length-4)
    }
}
