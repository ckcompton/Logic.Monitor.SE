---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Import-LMDevicesFromCSV

## SYNOPSIS
Imports list of devices based on specified CSV file

## SYNTAX

### Import (Default)
```
Import-LMDevicesFromCSV -FilePath <String> [-PassThru] [-CollectorId <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Sample
```
Import-LMDevicesFromCSV [-GenerateExampleCSV] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Imports list of devices based on specified CSV file.
This will also create any groups specified in the hostgroups field so they are not required to exist ahead of import.
Hostgroup should be the intended full path to the device.
You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

## EXAMPLES

### EXAMPLE 1
```
Import-LMDevicesFromCSV -FilePath ./ImportList.csv -PassThru -CollectorId 8
```

## PARAMETERS

### -FilePath
{{ Fill FilePath Description }}

```yaml
Type: String
Parameter Sets: Import
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateExampleCSV
{{ Fill GenerateExampleCSV Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Sample
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{ Fill PassThru Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorId
{{ Fill CollectorId Description }}

```yaml
Type: Int32
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: 0
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

### None. Does not accept pipeline input.
## OUTPUTS

## NOTES
Assumes csv with the headers ip,displayname,hostgroup,collectorid,description,property1,property2,property\[n\].
Ip, displayname and collectorid are the only required fields.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor.SE]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE]()

