[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)
