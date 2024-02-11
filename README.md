[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## 1.5.3
###### New Cmdlets:
- **Import-LMDevicesFromCSV**: 
  - Cmdlet allows for a more advanced CSV import over the LM Portal CSV import feature. Headers available for use include: ip,displayname,hostgroup,description,collectorid. Any additional headers are treating as custom properties and will be included with the import. This cmdlet will also create any groups not present during import so they do not need to be provisioned ahead of time.

```powershell
Import-LMDevicesFromCSV -FilePath ./device_list.csv
```

###### Updated Cmdlets:
- **Import-LMNetscanTemplate**: 
  - Cmdlet now supports importing netscan templates for the following technologies:
  - Palo Alto Prisma
  - Aruba Edge Connect

[Previous Release Notes](RELEASENOTES.md)