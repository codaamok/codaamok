---
external help file: codaamok-help.xml
Module Name: codaamok
online version: https://github.com/OneScripter/WmiExec
schema: 2.0.0
---

# WmiExec

## SYNOPSIS
Execute command remotely and capture output, using only WMI.
Copyright (c) Noxigen LLC.
All rights reserved.
Licensed under GNU GPLv3.

## SYNTAX

```
WmiExec [[-ComputerName] <String>] [[-Command] <String>] [<CommonParameters>]
```

## DESCRIPTION
This is proof of concept code.
Use at your own risk!

Execute command remotely and capture output, using only WMI.
Does not reply on PowerShell Remoting, WinRM, PsExec or anything
else outside of WMI connectivity.

## EXAMPLES

### EXAMPLE 1
```
.\WmiExec.ps1 -ComputerName SFWEB01 -Command "gci c:\; hostname"
```

## PARAMETERS

### -ComputerName
{{ Fill ComputerName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
{{ Fill Command Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
========================================================================
    NAME:		WmiExec.ps1
    
    AUTHOR:	Jay Adams, Noxigen LLC
                
    DATE:		6/11/2019
    
    Create secure GUIs for PowerShell with System Frontier.
    https://systemfrontier.com/powershell
==========================================================================

## RELATED LINKS

[https://github.com/OneScripter/WmiExec](https://github.com/OneScripter/WmiExec)

