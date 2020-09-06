function ConvertTo-ByteArrayString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String
    )
    begin { }
    process {
        [System.Text.Encoding]::UTF8.GetBytes($String)
    }
}
