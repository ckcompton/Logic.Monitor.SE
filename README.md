[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.8.1
- **Initialize-LMStandardNormProps**:
  - Initializes standard normalized properties in LogicMonitor.
    - Iterates through a list of standard property aliases (e.g., "location.region", "owner", etc.).
    - For each alias, it calls New-LMNormalizedProperties if the alias is missing,
       or Set-LMNormalizedProperties if it is partially missing some properties.

[Previous Release Notes](RELEASENOTES.md)
