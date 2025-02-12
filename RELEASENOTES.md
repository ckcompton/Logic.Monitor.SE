## Version 1.7.3
###### **New Cmdlets**:
- **Add-LMDeviceToDeviceGroup**:
  - This cmdlet adds a device to a device group, maintaining the device's existing group membership.
  ```
  #Adds a device to a device group.
  Add-LMDeviceToDeviceGroup -GroupName "Device Group Name" -Id "Device ID" -PassThru
  ```

- **Remove-LMDeviceFromDeviceGroup**:
  - This cmdlet removes a device from a device group, maintaining the device's existing group membership.
  ```
  #Removes a device from a device group.
  Remove-LMDeviceFromDeviceGroup -GroupName "Device Group Name" -Id "Device ID" -PassThru
  ```
###### **Updated Cmdlets**:
- **Import-LMDeviceGroupsFromCSV**:
  - Fixed an issue where the function would not run due to an null value being passed to the function, this issue is only present in version 1.7.2.
- **Initialize-LMPOVSetup**:
  - Fixed an issue that was preventing using the new LogSource deployment option when specifying the switch *-SetupWindowsLogs*.

## Version 1.7.2
###### **New Cmdlets**:
- **Export-LMCloudInventory**:
  - This cmdlet exports cloud inventory data from LogicMonitor to a CSV file. It supports exporting data for AWS, Azure, and GCP.
  ```
  #Exports cloud inventory data for AWS.
  Export-LMCloudInventory -CloudType AWS -OutputFilePath "C:\Path\To\Output"

  #Exports cloud inventory data for Azure.
  Export-LMCloudInventory -CloudType Azure -OutputFilePath "C:\Path\To\Output"
  ```
###### **Updated Cmdlets**:
- **Import-LMNetScanTemplate**: 
  - Updated templates to include the latest set of properties and filters available in LogicMonitor.
- **Import-LMDevicesFromCSV**: 
  - Added logic to correct hostpath if using an backslash instead of a forward slash when specifying the device group path.
- **Import-LMDeviceGroupsFromCSV**:
  - Added logic to correct fullpath if using an backslash instead of a forward slash when specifying the device group path.
- **Initialize-LMPOVSetup**: 
  - Added new dynamic groups for grouping devices by cloud pricing categories.
  - Added switch *-WindowsLogSource* to use Windows Event LogSources instead of the legacy Windows Event Logs datasource. The default behavior will be to use the legacy datasource for backwards compatibility.
- **Import-LMMerakiCloud**:
  - Deprecated cmdlet. Meraki is now supported via the *Import-LMNetScanTemplate* cmdlet with the *NetscanType* parameter set to *Meraki*.

## Version 1.7.1
###### **Important Note**:
- **Updated Cmdlet Documentation**:
  - All cmdlets should now have examples and full synopsis documentation. Use ```Get-Help <cmdlet_name>``` to see updated help info.

###### **Updated Cmdlets**:
- **Import-LMDevicesFromCSV**: 
  - Fixed bug introduced in 1.7 when trying to generate example csv.
- **Import-LMNetScanTemplate**: 
  - Updated vSphere template to include LM API properties along with hostname.source.
- **Initialize-LMPOVSetup**: 
  - Updated Meraki dynamic group appliesTo, to leverage the new meraki.productType properties.

## Version 1.7
###### **Important Note**:
- **Updated Cmdlet Documentation**:
  - All cmdlets should now have examples and full synopsis documentation. Use ```Get-Help <cmdlet_name>``` to see updated help info.

###### **New Cmdlets**:
- **Import-LMMultiCredentialConfig**:
  - This cmdlet imports multi-credential configuration for LogicMonitor. It allows you to specify multi SNMP and SSH credentials either as objects or by providing a CSV file path. It also provides options to generate example CSV files and specify the credential group and import group names.
  ```
  #Imports multi-credential configuration using SNMP and SSH credentials provided as objects. The dynamic credential groups will be created under the "MyCredentialGroup" group, and the device onboard group will be called "MyImportGroup".
  Import-LMMultiCredentialConfig -SNMPCredentialsObject $SNMPCredentials -SSHCredentialsObject $SSHCredentials -CredentialGroupName "MyCredentialGroup" -ImportGroupName "MyImportGroup"

  #Imports multi-credential configuration using SNMP and SSH credentials provided in CSV files located at the specified file paths.
  Import-LMMultiCredentialConfig -SNMPCsvFilePath "C:\Path\To\SNMPCredentials.csv" -SSHCsvFilePath "C:\Path\To\SSHCredentials.csv"

  #Generates example CSV files for SSH and SNMP credentials.
  Import-LMMultiCredentialConfig -GenerateExampleCSV
  ```


###### **Updated Cmdlets**:
- **Import-LMDevicesFromCSV**: 
  - Added the ability to specify an ABCG as part of the import process. The ABCG id can be set globally using the ```-AutoBalancedCollectorGroupId``` parameter or by setting the value of ```abcgid``` in the reference CSV file. If using ABCGs you should set the ```collectorid``` to 0.

## 1.6.3
###### Important Note:
- **Updated Cmdlet Documentation**:
  - All cmdlets should now have examples and full synopsis documentation. Use ```Get-Help <cmdlet_name>``` to see updated help info.

###### Updated Cmdlets:
- **Import-DeviceDedupe**: 
  - Renamed cmdlet to be inline with the naming scheme for exisitng cmdlets. Going forward this cmdlet is now exported under the name **Import-LMDeviceDedupe**.

- **Submit-LMDataModel(Concurrent)**:
  - Both cmdlets have been updated to skip credential validation in order to reduce API calls.
  - Cmdlets will now check if PushModules created by model submission have a 600 second collection interval and if not present will be updated automatically. This prevents graphing gaps when PushMetrics submission is set to a 10 minute interval.

 - **Import-LMNetscanTemplate**:
   - Updated netscan properties to reflect latest versions of enhanced netscans. Also updated cached netscan scripts to reflect latest netscan versions in the event pulling them from the support site fails.

## 1.6.2
###### Important Note:
- **PowerShell Core Minimum Version**:
  - Starting with version 1.6.1 and above, the minimum version of PowerShell required to use the Logic.Monitor.SE module has be bumped from 7.0 -> 7.4. Ensure you are on the latest version of PSCore before you attempt to upgrade to 1.6.1. This change was made to allow for usage of the newer capabilities avaiable in the LTS verison of PSCore. The Logic.Monitor module will remain at a required version of 5.1.

###### New Cmdlets:
- **Invoke-LMPushMetricKeepAlive**: 
  - Cmdlet for use with Invoke-LMDataModelRunner in order to keep PushMetrics devices alive when ingesting PushMetric data at a rate greater than 5 minutes.

###### Updated Cmdlets:
- **Import-LMDevicesFromCSV**: 
  - Fixed bug that would not allow a property to be set if it was not set for every device set for import.
  
## 1.6.1
###### Important Note:
- **PowerShell Core Minimum Version**:
  - Starting with version 1.6.1, the minimum version of PowerShell required to use the Logic.Monitor.SE module has be bumped from 7.0 -> 7.4. Ensure you are on the latest version of PSCore before you attempt to upgrade to 1.6.1. This change was made to allow for usage of the newer capabilities avaiable in the LTS verison of PSCore. The Logic.Monitor module will remain at a required version of 5.1.

###### New Cmdlets:
- **Set-LMDataModel**: 
  - Cmdlet allows modification of existing data models Currently limited to model name, displayname, properties and simulaiton type. This initial release will allow for some basic information editing but will be opened up to allow data and other instance information to be modified in a future release.

```powershell
Set-LMDataModel -ModelObject $ModelObject -Properties @{"new.prop"="value"}
```

###### Updated Cmdlets:
- **Submit-LMDataModel**: 
  - Updated data generation for models without reference data. Currently supported metric types are: IO-Latency, SpaceUsage, Status, Percentage and Rate.
  - Added SeedValue functionality to allow for bell curve generation of data models.

- **Submit-LMDataModelConcurrent**: 
  - Updated data generation for models without reference data. Currently supported metric types are: IO-Latency, SpaceUsage, Status, Percentage and Rate.
  - Added SeedValue functionality to allow for bell curve generation of data models.
  
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


## 1.5.3
###### New Cmdlets:
- **Import-LMDevicesFromCSV**: 
  - Cmdlet allows for a more advanced CSV import over the LM Portal CSV import feature. Headers available for use include: ip,displayname,hostgroup,description,collectorid. Any additional headers are treating as custom properties and will be included with the import. This cmdlet will also create any groups not present during import so they do not need to be provisioned ahead of time.

```powershell
Import-LMDevicesFromCSV -FilePath ./device_list.csv
```

###### Updated Cmdlets:
- **Import-LMNetscanTemplate**: 
  - Cmdlet now supports importing netscan templates for the following technologies:
  - Palo Alto Prisma
  - Aruba Edge Connect

## 1.5.1
###### Updated Cmdlets:
- **Import-LMNetscanTemplate**: 
  -  Cmdlet now supports importing netscan templates for the following technologies:
  -   Cisco Meraki
  -   Cisco SDWAN
  -   Cisco Catlayst Center Wireless
  -   Juniper Mist
  -   VMware vSphere

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

## 1.4.3-5
###### Updated Commands:
**Initalize-LMPOVsetup**: 
- Alert Analysis Dashboard setup now includes support for device groups, if deploying this in POV you should always deploy the latest version.

## 1.4.2
###### Updated Commands:
**Initalize-LMPOVsetup**: 
- Alert Analysis Dashboard deployment can be deployed with a seperate Switch -SetupAlertAnalysis in addition the the -IncludeDefaults switch.

## 1.4.1
###### Updated Commands:
**Build-LMDataModel**: 
- When modeling devices with a polling interval larger than 12 hours, we will not extract 3 months of datapoints to have enough granularity when replaying the model.

## 1.4
###### Bug Fixes:
**Build-LMDataModel**: 
- Fix bug causing datasource group name to export as null even when a group name was present on the model device.

###### Enhancements:
**Build-LMDataModel**: 
- Running without the **-Debug** parameter will now display export progress.
- Added *privToken* and *authToken* to list of restricted properties for export
- Properties starting with *auto.snmp* and *auto.network* will be excluded from export by default
- *Null* properties will not longer be included in model export
- *&* is an invalid PushMetric instance name character and will be replaced with an *underscore* when part of an instance name

**Invoke-LMDataModelRunner**: 
- Added Multi-threading support for datasource submission. Previously only models were multi threaded but you can now use the switch **-MultiThreadDatasourceSubmission** to submit datasources in parellel. This switch will use the same **-ConcurrencyLimit** parameter that is used for processing data models.

**Submit-LMDataModel**: 
- Remove parameter support for **-ModelJson** as its not needed since it already accepts the model object
- If no data is found for a data point that is part of a model reply, it will now default to generating random data based on estimated metric type. Previously the behavior was to jus default to a value of 0.

###### New Commands:
**Submit-LMDataModelConccurent**: 
- New command to allow submitting datasources in a multi thread fashion similar to how **Invoke-LMModelRunner** multi threads model submission. Because this command runs in multiple threads it requires **-Account** and **-BearerToken parameters** to be set so each thread can connect to the required portal.