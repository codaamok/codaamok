---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Add-FileAssociation

## SYNOPSIS
Set user file associations

## SYNTAX

```
Add-FileAssociation [-Extension] <Object> [-TargetExecutable] <String> [[-ftypeName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Define a program to open a file extension

## EXAMPLES

### EXAMPLE 1
```
$HT = @{
    Extension = '.txt'
    TargetExecutable = "C:\Program Files\Notepad++\notepad++.exe"
}
Add-FileAssociation @HT
```

### EXAMPLE 2
```
$HT = @{
    Extension = '.xml'
    TargetExecutable = "C:\Program Files\Microsoft VS Code\Code.exe"
    FtypeName = 'vscode'
}
Add-FileAssociation @HT
```

## PARAMETERS

### -Extension
The file extension to modify

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetExecutable
The program to use to open the file extension

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ftypeName
Non mandatory parameter used to override the created file type handler value

```yaml
Type: String
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
Found here: https://gist.github.com/p0w3rsh3ll/c64d365d15f6f39116dba1a26981dc68#file-add-fileassociation-ps1 https://p0w3rsh3ll.wordpress.com/2018/11/08/about-file-associations/

## RELATED LINKS
