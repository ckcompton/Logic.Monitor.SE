[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)