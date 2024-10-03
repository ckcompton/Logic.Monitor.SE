[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)
