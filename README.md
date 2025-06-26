[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.8.2
- Some cmdlets present in the this module have been migrated into the core Logic.Monitor module. Customers have been asking for some of the modules we use during POV and since they are aimed at helping users automate and manage their LogicMonitor portals it makes sense for them to be available to the broader audience. The following cmdlets have since been re-homed under the Logic.Monitor core module starting in *v7.3.1* of the core module:
  - **Invoke-LMDeviceDedupe**
  - **Import-LMDevicesFromCSV**
  - **Import-LMDeviceGroupsFromCSV**
  - **Find-LMDashboardWidgets**
  - **Copy-LMDevicePropertyToGroup**
  - **Copy-LMDevicePropertyToDevice**

[Previous Release Notes](RELEASENOTES.md)
