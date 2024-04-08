---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Get-LMPOVActivityReport

## SYNOPSIS
Generate list of active users in a portal along with associated activities.

## SYNTAX

```
Get-LMPOVActivityReport [[-DaysOfActivity] <Int32>]
```

## DESCRIPTION
Generate list of active users in a portal along with associated activities.

## EXAMPLES

### EXAMPLE 1
```
Get-LMPOVActivityReport -DaysOfActivity 30
```

## PARAMETERS

### -DaysOfActivity
{{ Fill DaysOfActivity Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 14
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. Does not accept pipeline input
## OUTPUTS

## NOTES
Must be connected to the portal you want to pull activity reports from ahead of time.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor.SE]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE]()

