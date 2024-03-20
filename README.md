[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

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

[Previous Release Notes](RELEASENOTES.md)