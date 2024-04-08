---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Rename-LMDevicesFromProperty

## SYNOPSIS
This function renames Logic Monitor devices based on a specified property.

## SYNTAX

```
Rename-LMDevicesFromProperty [-Device] <Object[]> [[-SourceProperty] <String>] [[-PropertyType] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Rename-LMDevicesFromProperty function renames devices in Logic Monitor based on a specified property. 
The property can be a system property, a custom property, or an auto property. 
The function uses the Set-LMDevice cmdlet to rename the devices.

## EXAMPLES

### EXAMPLE 1
```
Rename-LMDevicesFromProperty -Device $Device -SourceProperty "system.hostname" -PropertyType "system"
```

This command renames the device represented by the $Device object based on the system property "system.hostname".

## PARAMETERS

### -Device
The device or devices to be renamed.
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

### -SourceProperty
The property based on which the devices are to be renamed.
Defaults to "system.sysname".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: System.sysname
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyType
The type of the property.
Can be "system", "custom", or "auto".
Defaults to "system".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: System
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

### System.Object[]. You can pipe a device or an array of devices to Rename-LMDevicesFromProperty.
## OUTPUTS

### The function does not return any output. It displays a message for each device that is renamed or skipped.
## NOTES
The function throws an error if it fails to rename a device.

## RELATED LINKS
