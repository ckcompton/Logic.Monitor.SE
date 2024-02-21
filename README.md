[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## 1.6
###### New Cmdlets:
- **Import-LMDefaultDynamicGroups**: 
  - Cmdlet allows for recreation of the out of box default dynamic groups. This is useful if working with a customer that has accidently blown them away and needs to rebuild them for whatever purpose. You can optionally specify a -ParentGroupId and -RootGroupName if looking for a different location/name otherwise the default location (1) and name (Devices by Type) will be used.

```powershell
Import-LMDefaultDynamicGroups -ParentGroupId 1 -RootGroupName "Devices by Type"
```

- **Import-LMDeviceGroupsFromCSV**: 
  - Cmdlet allows for an advanced CSV import for the creation of device groups. Headers available for use include: name,fullpath,description,appliesTo. Any additional headers are treated as custom properties and will be included with the import. This cmdlet will also create any groups not present during import that are part of the fullPath value so they do not need to be provisioned ahead of time.

```powershell
Import-LMDeviceGroupsFromCSV -FilePath ./device_group_list.csv -PassThru
```

- **Invoke-LMDeviceDedupe**: 
  - Cmdlet will search a portal for duplicate devices and allow you to remove them. By default the command will search all devices in a portal but an optional parameter -DeviceGroupId can be specified to restrict devices used for search. If duplicates are set to be removed the newest device will be the one that is purged from the portal. It is recomended to run the command with the -ListDuplicates parameter to see the results prior to removing. You can also specify exclusions for specific IPs, deviceTypes and sysname values.

```powershell
#List duplicates that exist in device group 8
Import-LMDeviceDedupe -DeviceGroupId 8 -ListDuplicates

#Remove duplicates that exist in device group 8
Import-LMDeviceDedupe -DeviceGroupId 8 -RemoveDuplicates

```

###### Updated Cmdlets:
- **Import-LMNetscanTemplate**: 
  - Added support running multiple datasource names in a single pass using the -DatasourceNames parameter. Additionally all widget types are supported for search, previously only graph widget were being checked for datasource matches.

```powershell
Find-LMDashboardWidgets -DatasourceNames @("SNMP_NETWORK_INTERFACES","VMWARE_VCETNER_VM_PERFORMANCE")
```

- **Get-LMPOVActivityReport**: 
  - Added custom object type for results.
  - Added connected portal indicator to console output

- **Import-LMNetscanTemplate**: 
  - Added support for automatically scraping the LM support site for the latest version of groovy code for each supported template. This ensures the command will always use the latest version available on the support site.

- **Import-LMDevicesFromCSV**: 
  - Added progress indicator to show creation process.
  - Added -GenerateExampleCSV parameter to generate an example file to use for reference on reuired csv format.
  - Added -PassThru command to allow for return of results at completion of the import. By default no objects are returned.

[Previous Release Notes](RELEASENOTES.md)