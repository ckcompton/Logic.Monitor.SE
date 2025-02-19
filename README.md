[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor.SE/actions/workflows/main.yml)

# Logic.Monitor.SE
PowerShell modules with utilities used by Sales Engineering.

# Change List

## Version 1.7.5

###### **New Cmdlets**:
- **Find-LMLogAnomalyAlerts**:
  - New cmdlet that identifies and analyzes alerts with associated log anomalies, including sentiment analysis.
  - Supports custom date ranges and batch processing options.
  - Correlates alerts with anomalous logs within a 30-minute window.
- **Format-LMLogAnomalyResults**:
  - Formats log anomaly analysis results in a clear, color-coded console output.
  - Displays detailed alert information and associated logs with sentiment scores.
- **Export-LMLogAnomalyReport**:
  - Generates comprehensive HTML reports for log anomaly analysis results.
  - Features interactive charts, severity distribution analysis, and detailed data tables.
  - Includes export capabilities (CSV, Excel, PDF) and responsive design.
  - Requires PSWriteHTML module.

[Previous Release Notes](RELEASENOTES.md)
