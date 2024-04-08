---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# ConvertTo-LMAzureDynamicGroups

## SYNOPSIS
Create a series of dynamic groups for each azure subscription in a portal

## SYNTAX

```
ConvertTo-LMAzureDynamicGroups [-AzureRootGroupId] <String> [[-ParentGroupId] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Create a series of dynamic groups for each azure subscription in a portal

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-LMAzureDynamicGroups -AzureRootGroupId 85
```

## PARAMETERS

### -AzureRootGroupId
{{ Fill AzureRootGroupId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
{{ Fill ParentGroupId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
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

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
Created groups will be placed in a main group called Azure Resources by Subscription in the parent group specified by the -ParentGroupId parameter

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor.SE]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE]()

