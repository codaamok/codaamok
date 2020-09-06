---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Read-SMSTSLog

## SYNOPSIS

## SYNTAX

```
Read-SMSTSLog [[-Computer] <String>] [[-Path] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Parses through the SMSTS log and returns the steps which succeeded, steps which failed, comptuer name, timestamp, and log name.

## EXAMPLES

### EXAMPLE 1
```
Read-SMSTSLog.ps1 -Computer PC01
```

### EXAMPLE 2
```
Read-SMSTSLog.ps1 -Path X:\Windows\Temp\
```

## PARAMETERS

### -Computer
To view a remote machine's logs use this parameter to define the machine name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:ComputerName"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
If for some reason the SMSTS log is not located in C:\Windows\CCM\Logs, use this parameter to define the folder path (Accepts UNC Paths)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "\\$computer\c$\Windows\CCM\Logs"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{ Fill Credential Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Version:        1.0
Author:         Amar Rathore
Creation Date:  2019-03-25

## RELATED LINKS
