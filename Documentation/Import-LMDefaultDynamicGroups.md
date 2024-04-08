---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Import-LMDefaultDynamicGroups

## SYNOPSIS
Rebuild orginal out of box dyanmic resource groups.

## SYNTAX

```
Import-LMDefaultDynamicGroups [[-ParentGroupId] <String>] [[-RootGroupName] <String>]
```

## DESCRIPTION
Rebuild orginal out of box dyanmic resource groups.

## EXAMPLES

### EXAMPLE 1
```
Import-LMDefaultDynamicGroups -ParentGroupId 1 -RootGroupName "Devices by Type"
```

## PARAMETERS

### -ParentGroupId
{{ Fill ParentGroupId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -RootGroupName
{{ Fill RootGroupName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Devices by Type
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. Does not accept pipeline input.
## OUTPUTS

## NOTES
You can specify a different -RootGroupName and -ParentGroupId if you want to deploy under a different location/name.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor.SE]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE]()

