[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.7
###### **Important Note**:
- **Updated Cmdlet Documentation**:
  - All cmdlets should now have examples and full synopsis documentation. Use ```Get-Help <cmdlet_name>``` to see updated help info.

###### **New Cmdlets**:
- **Import-LMMultiCredentialConfig**:
  - This cmdlet imports multi-credential configuration for LogicMonitor. It allows you to specify multi SNMP and SSH credentials either as objects or by providing a CSV file path. It also provides options to generate example CSV files and specify the credential group and import group names.
  ```

  #Imports multi-credential configuration using SNMP and SSH credentials provided as objects. The dynamic credential groups will be created under the "MyCredentialGroup" group, and the device onboard group will be called "MyImportGroup".
  Import-LMMultiCredentialConfig -SNMPCredentialsObject $SNMPCredentials -SSHCredentialsObject $SSHCredentials -CredentialGroupName "MyCredentialGroup" -ImportGroupName "MyImportGroup"

  #Imports multi-credential configuration using SNMP and SSH credentials provided in CSV files located at the specified file paths.
  Import-LMMultiCredentialConfig -SNMPCsvFilePath "C:\Path\To\SNMPCredentials.csv" -SSHCsvFilePath "C:\Path\To\SSHCredentials.csv"

  #Generates example CSV files for SSH and SNMP credentials.
  Import-LMMultiCredentialConfig -GenerateExampleCSV
  ```


###### **Updated Cmdlets**:
- **Import-LMDevicesFromCSV**: 
  - Added the ability to specify an ABCG as part of the import process. The ABCG id can be set globally using the ```-AutoBalancedCollectorGroupId``` parameter or by setting the value of ```abcgid``` in the reference CSV file. If using ABCGs you should leave the ```collectorgroupid``` blank and set the ```collectorid``` to 0.

[Previous Release Notes](RELEASENOTES.md)
