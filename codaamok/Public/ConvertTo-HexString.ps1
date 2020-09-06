function ConvertTo-HexString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String
    )
    begin { }
    process {
        foreach ($char in $String.ToCharArray()) {
            [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($char))
        }
    }
}
