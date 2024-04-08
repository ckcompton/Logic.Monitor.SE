---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Set-LMDataModel

## SYNOPSIS
This function sets the data model for a Logic Monitor device.

## SYNTAX

```
Set-LMDataModel [-ModelObject] <Object> [[-Properties] <Hashtable>] [[-Hostname] <String>]
 [[-DisplayName] <String>] [[-SimulationType] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDataModel function takes a model object and optional parameters for properties, hostname, display name, and simulation type. 
It modifies the model object based on the provided parameters and sets the data model for the device.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDataModel -ModelObject $Model -Hostname "NewHostname" -DisplayName "NewDisplayName" -SimulationType "random"
```

This command modifies the model object represented by the $Model variable, setting the hostname to "NewHostname", the display name to "NewDisplayName", and the simulation type to "random".

## PARAMETERS

### -ModelObject
The model object to be modified.
This is a mandatory parameter.
The object must be a valid JSON object and must contain the properties "Datasources", "Properties", "DisplayName", "HostName", and "SimulationType".

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

### -Properties
A hashtable of properties to be added to the model object.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
The hostname to be set in the model object.

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

### -DisplayName
The display name to be set in the model object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SimulationType
The simulation type to be set in the model object.
Can be "8to5", "random", "replication", or "replay_model".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### System.Object. You can pipe a model object to Set-LMDataModel.
## OUTPUTS

### The function reutrns an updated model object
## NOTES
The function throws an error if the model object is not a valid JSON object or if it does not contain the required properties.

## RELATED LINKS
