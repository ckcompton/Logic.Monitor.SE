[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)