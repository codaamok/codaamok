---
external help file: codaamok-help.xml
Module Name: codaamok
online version:
schema: 2.0.0
---

# Get-ScheduledTasks

## SYNOPSIS
Get scheduled task information from a system
https://gallery.technet.microsoft.com/Get-ScheduledTasks-Get-d2207def

## SYNTAX

### COM (Default)
```
Get-ScheduledTasks [[-ComputerName] <String[]>] [-folder <String>] [-recurse] [-Path <String>]
 [-Exclude <String>] [<CommonParameters>]
```

### SchTasks
```
Get-ScheduledTasks [[-ComputerName] <String[]>] [-folder <String>] [-Exclude <String>] [-CompatibilityMode]
 [<CommonParameters>]
```

## DESCRIPTION
Get scheduled task information from a system

Uses Schedule.Service COM object, falls back to SchTasks.exe as needed.
When we fall back to SchTasks, we add empty properties to match the COM object output.

## EXAMPLES

### EXAMPLE 1
```
#Get scheduled tasks from the root folder of server1 and c-is-ts-91
```

Get-ScheduledTasks server1, c-is-ts-91

### EXAMPLE 2
```
#Get scheduled tasks from all folders on server1, not in a Microsoft folder
```

Get-ScheduledTasks server1 -recurse -Exclude "\\\\Microsoft\\\\"

### EXAMPLE 3
```
#Get scheduled tasks from all folders on server1, not in a Microsoft folder, and export in XML format (can be used to import scheduled tasks)
```

Get-ScheduledTasks server1 -recurse -Exclude "\\\\Microsoft\\\\" -path 'D:\Scheduled Tasks'

## PARAMETERS

### -ComputerName
One or more computers to run this against

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: host, server, computer

Required: False
Position: 1
Default value: Localhost
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -folder
Scheduled tasks folder to query. 
By default, "\"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: \
Accept pipeline input: False
Accept wildcard characters: False
```

### -recurse
If specified, recurse through folders below $folder.

Note:  We also recurse if we use SchTasks.exe

```yaml
Type: SwitchParameter
Parameter Sets: COM
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
If specified, path to export XML files

Details:
    Naming scheme is computername-taskname.xml
    Please note that the base filename is used when importing a scheduled task. 
Rename these as needed prior to importing!

```yaml
Type: String
Parameter Sets: COM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
If specified, exclude tasks matching this regex (we use -notmatch $exclude)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompatibilityMode
If specified, pull scheduled tasks only with the schtasks.exe command, which works against older systems.

Notes:
    Export is not possible with this switch.
    Recurse is implied with this switch.

```yaml
Type: SwitchParameter
Parameter Sets: SchTasks
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
Properties returned    : When they will show up
    ComputerName       : All queries
    Name               : All queries
    Path               : COM object queries, added synthetically if we fail back from COM to SchTasks
    Enabled            : COM object queries
    Action             : All queries. 
Schtasks.exe queries include both Action and Arguments in this property
    Arguments          : COM object queries
    UserId             : COM object queries
    LastRunTime        : All queries
    NextRunTime        : All queries
    Status             : All queries
    Author             : All queries
    RunLevel           : COM object queries
    Description        : COM object queries
    NumberOfMissedRuns : COM object queries

Thanks to help from Brian Wilhite, Jaap Brasser, and Jan Egil's functions:
    http://gallery.technet.microsoft.com/scriptcenter/Get-SchedTasks-Determine-5e04513f
    http://gallery.technet.microsoft.com/scriptcenter/Get-Scheduled-tasks-from-3a377294
    http://blog.crayon.no/blogs/janegil/archive/2012/05/28/working_2D00_with_2D00_scheduled_2D00_tasks_2D00_from_2D00_windows_2D00_powershell.aspx

## RELATED LINKS
