---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Invoke-LMDataModelRunner

## SYNOPSIS
Invokes Submit-LMDataModel for an array of models

## SYNTAX

```
Invoke-LMDataModelRunner -BearerToken <String> -AccountName <String> -ModelPath <String>
 [-LogSourceName <String>] [-LogFileName <String>] [-LogResult] [-LogResourceId <Hashtable>]
 [-ConcurrencyLimit <Int32>] [-RunPreFlightScripts] [<CommonParameters>]
```

## DESCRIPTION
Based on the specified ModelPath, all discovered models are submitted to Submit-LMDataModel.
ModelPath should contain a subfolder called Models which contains the generated model JSON files and additionally a Scipts folder with an pre processing scripts you want executed priot to model submission.

## EXAMPLES

### EXAMPLE 1
```
-LogSourceName "DL-PMv1" -LogFileName Runner.txt -LogResult -LogResourceId @{"system.deviceId"="123"}
```

## PARAMETERS

### -BearerToken
Logic Monitor bearer token for connecting to the targeted portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
LogicMontior Portal to submit models to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModelPath
File path where models are located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogSourceName
Submitted Logs will have a log source name appended as metadata, defaults to PMv1 if not set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PMv1
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFileName
File name to use for transcript files, defaults to Runner.txt if not set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: RunnerLog.txt
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogResult
Switch to enable logging of submission results to LogicMonitor.
If not set no logs will be generated.

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

### -LogResourceId
Hashtable containing the required mapping info for lm logs.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConcurrencyLimit
Number of models to process in parallel, defaults to 5.
Running too many concurrently can result in 429 errors.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunPreFlightScripts
Switch to enable the procesing of scripts included in the module directory under the script folder.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor.SE]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE]()

