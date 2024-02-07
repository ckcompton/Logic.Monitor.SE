# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## 1.5
###### Updated Cmdlets:
- **Import-LMNetscanTemplate**: 
  - Updated Netscan scripts to latest versions and fixed bug causing Juniper and Meraki switches to deploy the incorrect netscan template

###### New Cmdlets:
- **Find-LMDashboardWidgets**: 
  - Returns a list of dashboard widgets that contain a specified datasource. Useful for checking dashboards that might contain a deprecated module and need to be updated.

- **ConvertTo-LMAzureDynamicGroups**: 
  - Takes a azure root resource group and creates a dynamic resource structure by resource type broken down by subscription.

###### Usage Examples:
```powerhsell
#Use Azure Root Group Id 85 and create a Resource by Sub folder structure under parent group id 1
ConvertTo-LMAzureDynamicGroups -AzureRootGroupId 85 -ParentGroupId 1

#Look for all Dashboard widgets containg the datasource VMware_vSphere_VirtualMachineDiskCapacity only if they exist in a dashboard that has Virtualization in the group path
Find-LMDashboardWidgets -DatasourceName "VMware_vSphere_VirtualMachineDiskCapacity" -GroupPathSearchString "*Virtualization*"
```

[Previous Release Notes](RELEASENOTES.md)