---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Initialize-LMPOVSetup

## SYNOPSIS
This function initializes the Logic Monitor (POV) setup for SEs by automating various tasks required during POV setup.

## SYNTAX

### Individual (Default)
```
Initialize-LMPOVSetup [-Website <String>] [-WebsiteHttpType <String>] [-PortalMetricsAPIUsername <String>]
 [-LogsAPIUsername <String>] [-SetupWebsite] [-SetupPortalMetrics] [-SetupAlertAnalysis] [-SetupLMContainer]
 [-LMContainerAPIUsername <String>] [-MoveMinimalMonitoring] [-CleanupDynamicGroups] [-SetupWindowsLMLogs]
 [-IncludeDefaults] [-SetupCollectorServiceInsight] [-WindowsLMLogsEventChannels <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### All
```
Initialize-LMPOVSetup [-Website <String>] [-WebsiteHttpType <String>] [-PortalMetricsAPIUsername <String>]
 [-LogsAPIUsername <String>] [-LMContainerAPIUsername <String>] [-IncludeDefaults]
 [-WindowsLMLogsEventChannels <String>] [-RunAll] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### PostPOV-Readonly
```
Initialize-LMPOVSetup [-ReadOnlyMode] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### PostPOV-RevertReadonly
```
Initialize-LMPOVSetup [-RevertReadOnlyMode] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Initialize-LMPOVSetup function sets up various components of the Logic Monitor POV. 
It can set up the website, portal metrics, alert analysis, and LM container. 
The setup for each component can be controlled individually or all at once.

## EXAMPLES

### EXAMPLE 1
```
Initialize-LMPOVSetup -RunAll -IncludeDefaults -Website example.com
```

This command runs all setup processes including default options and creates a webcheck for example.com.

## PARAMETERS

### -Website
The name of the website to be set up.
This parameter is used in both 'All' and 'Individual' parameter sets.

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteHttpType
The HTTP type of the website.
Defaults to "https".
This parameter is used in both 'All' and 'Individual' parameter sets.

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: Https
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalMetricsAPIUsername
The username for the Portal Metrics API.
Defaults to "lm_portal_metrics".
This parameter is used in both 'All' and 'Individual' parameter sets.

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: Lm_portal_metrics
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogsAPIUsername
The username for the Logs API.
Defaults to "lm_logs".
This parameter is used in both 'All' and 'Individual' parameter sets.

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: Lm_logs
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupWebsite
A switch to control the setup of the website.
This parameter is used in the 'Individual' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupPortalMetrics
A switch to control the setup of the portal metrics.
This parameter is used in the 'Individual' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupAlertAnalysis
A switch to control the setup of the alert analysis.
This parameter is used in the 'Individual' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupLMContainer
A switch to control the setup of the LM container.
This parameter is used in the 'Individual' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMContainerAPIUsername
The username for the LM Container API.
Defaults to "lm_container".
This parameter is used in both 'All' and 'Individual' parameter sets.

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: Lm_container
Accept pipeline input: False
Accept wildcard characters: False
```

### -MoveMinimalMonitoring
{{ Fill MoveMinimalMonitoring Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CleanupDynamicGroups
{{ Fill CleanupDynamicGroups Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupWindowsLMLogs
{{ Fill SetupWindowsLMLogs Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDefaults
{{ Fill IncludeDefaults Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReadOnlyMode
{{ Fill ReadOnlyMode Description }}

```yaml
Type: SwitchParameter
Parameter Sets: PostPOV-Readonly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevertReadOnlyMode
{{ Fill RevertReadOnlyMode Description }}

```yaml
Type: SwitchParameter
Parameter Sets: PostPOV-RevertReadonly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupCollectorServiceInsight
{{ Fill SetupCollectorServiceInsight Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsLMLogsEventChannels
{{ Fill WindowsLMLogsEventChannels Description }}

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: Application,System
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAll
{{ Fill RunAll Description }}

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
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

### The function does not accept input from the pipeline.
## OUTPUTS

### The function does not return any output.
## NOTES
The function throws an error if it fails to set up any component.

## RELATED LINKS
