[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.8.4
### Updated Cmdlets
- **Update-LogicMonitorSEModule**: Hardened for non-blocking version checks; failures are logged via `Write-Verbose` and never terminate connecting cmdlets.
- **Export-LMDeviceConfigReport**: Fix bug with calling deprecated *Get-LMDeviceGroupDevices*.
- **Get-LMPOVActivityReport**: Fix bug with calling deprecated *Get-LMAuditLogs*.
- **Initialize-LMStandardNormProps**: Fix bug with calling deprecated *Get-LMNormalizedProperties*.

[Previous Release Notes](RELEASENOTES.md)
