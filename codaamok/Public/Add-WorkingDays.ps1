function Add-WorkingDays {
    # Chris Dent <3
    # https://discord.com/channels/618712310185197588/618857671608500234/913855890384371712
    param (
        [Parameter(Mandatory)]
        [int]$Days,

        [Parameter()]
        [object]$Date = (Get-Date)
    )

    $increment = $Days / [Math]::Abs($Days)
    do {
        $Date = $Date.AddDays($increment)
        
        if ($Date.DayOfWeek -notin 'Saturday', 'Sunday') {
            $Days -= $increment
        }
    } while ($Days)

    return $Date
}