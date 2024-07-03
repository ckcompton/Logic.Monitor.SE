[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)
