---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Invoke-LMPushMetricKeepAlive

## SYNOPSIS
This function invokes a keep-alive signal for Logic Monitor Push Metrics.

## SYNTAX

```
Invoke-LMPushMetricKeepAlive [-DeviceObject] <Object> [[-DatasourceGroupName] <Object>]
 [[-DatasourceName] <Object>] [[-DatasourceDisplayName] <Object>] [[-InstanceName] <Object>]
 [[-DataPointName] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMPushMetricKeepAlive function sends a keep-alive signal to a device using Logic Monitor's Push Metrics. 
It uses a device object passed as a parameter and has default values for various other parameters related to the datasource and datapoint.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMPushMetricKeepAlive -DeviceObject $Device
```

This command sends a keep-alive signal to the device represented by the $Device object.

## PARAMETERS

### -DeviceObject
The device object for which the keep-alive signal is to be sent.
This is a mandatory parameter and can be piped to the function.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DatasourceGroupName
The name of the datasource group.
Defaults to "Host Status".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Host Status
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceName
The name of the datasource.
Defaults to "PushMetricKeepAlive_PMv1".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: PushMetricKeepAlive_PMv1
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceDisplayName
The display name of the datasource.
Defaults to "PushMetric Keep Alive".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: PushMetric Keep Alive
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceName
The name of the instance.
Defaults to "PushMetric_Keep_Alive".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: PushMetric_Keep_Alive
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPointName
The name of the datapoint.
Defaults to "KeepAlive".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: KeepAlive
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

### PSCustomObject. You can pipe a device object to Invoke-LMPushMetricKeepAlive.
## OUTPUTS

### The function does not return any output.
## NOTES
The function throws an error if it fails to send the keep-alive signal.

## RELATED LINKS
