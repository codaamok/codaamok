---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Measure-ChildItem

## SYNOPSIS
Recursively measures the size of a directory.

## SYNTAX

```
Measure-ChildItem [[-Path] <String>] [-Unit <String>] [-Digits <Int32>] [-ValueOnly] [<CommonParameters>]
```

## DESCRIPTION
Recursively measures the size of a directory.

Measure-ChildItem uses  win32 functions, returning a minimal amount of information to gain speed.
Once started, the operation cannot be interrupted by using Control and C.
The more items present in a directory structure the longer this command will take.

This command supports paths longer than 260 characters.

## EXAMPLES

### EXAMPLE 1
```
Measure-ChildItem
```

Get the size of all items within the current directory.

### EXAMPLE 2
```
Get-ChildItem c:\users | Measure-ChildItem -Unit MB
```

Get the size of all child items of c:\users.

### EXAMPLE 3
```
Measure-ChildItem c:\windows -ValueOnly -Unit GB
```

Return the size of the c:\windows directory and return only the size in GB.

### EXAMPLE 4
```
Get-ChildItem \\server\share -Directory | Measure-ChildItem -Unit TB -Digits 5
```

Return the size of all items in a share.

## PARAMETERS

### -Path
The path to measure the size of.
Accepts pipeline input.
By default the size of the current working directory is measured.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 2
Default value: $pwd
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Unit
The units sizes should be displayed in.
By default, sizes are displayed in Bytes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: B
Accept pipeline input: False
Accept wildcard characters: False
```

### -Digits
When rounding, the number of digits to display after a decimal point.
By defaut sizes are rounded to two decimal places.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueOnly
Return the size value only, discards file, and directory counts and path information.

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
Thanks Chris Dent!
https://gist.github.com/indented-automation

## RELATED LINKS
