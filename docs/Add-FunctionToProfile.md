---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Add-FunctionToProfile

## SYNOPSIS
Add a function to your profile

## SYNTAX

```
Add-FunctionToProfile [-FunctionToAdd] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to append a function to your PowerShell profile.
You provide a function name, and if it has a script block
then it will be appended to your PowerShell profile with the function name provided.

## EXAMPLES

### EXAMPLE 1
```
Add-FunctionToProfile -FunctionToAdd 'Get-CMClientMaintenanceWindow'
```

## PARAMETERS

### -FunctionToAdd
The name of the function(s) you wish to add to your profile.
You can provide multiple.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
If a function doesn't have a script block, then it cannot be added to your profile
Cody is the man: https://github.com/CodyMathis123/CM-Ramblings/blob/master/Add-FunctionToProfile.ps1

## RELATED LINKS
