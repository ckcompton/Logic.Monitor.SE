[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.7.4
###### **Updated Cmdlets**:
- **Export-LMCloudInventory**:
  - Added -PassThru parameter to allow for the output to be returned to the caller.
- **Import-LMMultiCredentialConfig**:
  - Updated SNMP v2/v3 credential property values to properly reflect the expected format.

###### **New Cmdlets**:
- **Initialize-LMSITemplateSetup**:
  - Initial cmdlet to help support the setup and configuration of SI templates by setting up a set of standard mapped normalized properties.

[Previous Release Notes](RELEASENOTES.md)
