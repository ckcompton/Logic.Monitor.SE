[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.7.9
- **Start-LMSessionSyncServer**:
  - Fixed bug that was causing some 401 auth errors inadvertently.

- **Copy-LMDevicePropertytoGroup**:
  - Copies specified custom properties from a source device to one or more target device groups.The source device can be randomly selected from a group or explicitly specified. Properties are copied to the target groups whilepreserving other existing group properties.

  ```
  Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456 -PropertyNames "location","department"
  #Copies the location and department properties from device 123 to group 456.

  Copy-LMDevicePropertyToGroup -SourceGroupId 789 -TargetGroupId 456,457 -PropertyNames "location" -PassThru
  #Randomly selects a device from group 789 and copies its location property to groups 456 and 457, returning the updated groups.
  ```

## Version 1.7.8
- **Start-LMSessionSyncServer**:
  - Update Session Sync to support LMDA integration. Must be on 1.7.8 or later to use with LMDA.

[Previous Release Notes](RELEASENOTES.md)
