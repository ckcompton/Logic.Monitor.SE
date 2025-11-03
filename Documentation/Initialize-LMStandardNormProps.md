---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Initialize-LMStandardNormProps

## SYNOPSIS
Initializes standard normalized properties in LogicMonitor.

## SYNTAX

```
Initialize-LMStandardNormProps [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This script:
1.
Verifies that you are connected to LogicMonitor (via Connect-LMAccount).
2.
Iterates through a list of standard property aliases (e.g., "location.region", "owner", etc.).
3.
For each alias, it calls New-LMNormalizedProperty if the alias is missing,
   or Set-LMNormalizedProperty if it is partially missing some properties.

## EXAMPLES

### EXAMPLE 1
```
Initialize-LMStandardNormProps
```

This will attempt to create/update the standardized normalized properties in LogicMonitor.

## PARAMETERS

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

## OUTPUTS

## NOTES

## RELATED LINKS
