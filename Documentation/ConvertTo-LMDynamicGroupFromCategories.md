---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# ConvertTo-LMDynamicGroupFromCategories

## SYNOPSIS
Create a series of dynamic groups based off of active system.categories applied to your portal

## SYNTAX

```
ConvertTo-LMDynamicGroupFromCategories [[-ExcludeCategoryList] <String[]>] [[-DefaultGroupName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Created dynamic groups based on in use device categories

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-LMDynamicGroupFromCategories
```

## PARAMETERS

### -ExcludeCategoryList
{{ Fill ExcludeCategoryList Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @("TopoSwitch","snmpTCPUDP","LogicMonitorPortal","snmp","snmpUptime","snmpHR","Netsnmp","email rtt","email transit","collector","NoPing","NoHTTPS")
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultGroupName
{{ Fill DefaultGroupName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Devices by Category
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
Created groups will be placed in devices by type default resource group

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

