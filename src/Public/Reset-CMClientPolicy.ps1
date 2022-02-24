Function Reset-CMClientPolicy {
    param (
        [CimSession]$CimSession
    )

    $InvokeCimMethodSplat = @{
        ClassName    = "SMS_Client"
        Namespace    = "root\ccm"
        Name         = "ResetPolicy"
        ArgumustList = 1
    }   

    if ($PSBoundParameters.ContainsKey("CimSession")) {
        $InvokeCimMethodSplat["CimSession"] = $CimSession
    }

    Invoke-CimMethod @CimSession
}
