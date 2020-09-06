---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Get-Secure

## SYNOPSIS
Get a stored credential.

## SYNTAX

### Get (Default)
```
Get-Secure [-Name] <String> [-Clipboard] [-AsEnvironmentVariable] [<CommonParameters>]
```

### List
```
Get-Secure [-List] [-Clipboard] [-AsEnvironmentVariable] [<CommonParameters>]
```

## DESCRIPTION
Get a stored credential.
https://github.com/indented-automation/Indented.Profile/blob/master/Indented.Profile/public/Get-Secure.ps1

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
The name which identifies a credential.

```yaml
Type: String
Parameter Sets: Get
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -List
List all available credentials.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Clipboard
Do not copy the password to the clipboard.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsEnvironmentVariable
Store the password in an environment variable instead of returning a credential.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
