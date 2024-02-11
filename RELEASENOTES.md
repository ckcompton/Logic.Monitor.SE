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