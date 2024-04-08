---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Search-LMDeviceConfigBackup

## SYNOPSIS
This function searches for a specified pattern in the configuration backups of Logic Monitor devices.

## SYNTAX

```
Search-LMDeviceConfigBackup [-ConfigBackups] <Object[]> [-SearchPattern] <Regex>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Search-LMDeviceConfigBackup function takes an array of configuration backups and a search pattern as input. 
It searches for the pattern in the configuration content of each device and returns the results.

## EXAMPLES

### EXAMPLE 1
```
Search-LMDeviceConfigBackup -ConfigBackups $ConfigBackups -SearchPattern "hostname"
```

This command searches for the pattern "hostname" in the configuration backups represented by the $ConfigBackups array.

## PARAMETERS

### -ConfigBackups
An array of configuration backups for the devices.
This is a mandatory parameter and can be piped to the function.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SearchPattern
The pattern to search for in the configuration backups.
This is a mandatory parameter.

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object[]. You can pipe an array of configuration backups to Search-LMDeviceConfigBackup.
## OUTPUTS

### The function returns an array of custom objects. Each object represents a search result and contains the device display name, 
### the device poll timestamp in UTC, the device instance name, the configuration version, the line number where the match was found, 
### and the content of the match. If no match is found for a device, the line number and content are set to "No Match".
## NOTES
The function writes a message to the host for each device, indicating the number of search results found.

## RELATED LINKS
