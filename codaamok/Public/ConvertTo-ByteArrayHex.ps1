function ConvertTo-ByteArrayHex {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String
    )
    begin { }
    process {
        [Byte[]]$bytes = for ($i = 0; $i -lt $String.Length; $i += 2) {
            '0x{0}{1}' -f $String[$i], $String[$i + 1]
        }
        $bytes
    }
}
