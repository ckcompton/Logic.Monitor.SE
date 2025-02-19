# LogicMonitor Log Anomaly Analysis Guide

## Overview

This guide covers the usage of three cmdlets designed for analyzing log anomalies in LogicMonitor:
- `Find-LMLogAnomalyAlerts`: Discovers alerts with associated anomalous logs
- `Format-LMLogAnomalyResults`: Displays results in console
- `Export-LMLogAnomalyReport`: Generates interactive HTML reports

## Prerequisites

1. Active LogicMonitor portal connection
   ```powershell
   Connect-LMAccount
   ```

## Finding Log Anomalies

### Basic Search
```powershell
# Default: Last 14 days
Find-LMLogAnomalyAlerts

# Custom date range
Find-LMLogAnomalyAlerts -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date)
```

### Advanced Options
```powershell
# For larger environments
Find-LMLogAnomalyAlerts -MaxPages 20 -BatchSize 1000
```

### Parameters
| Parameter  | Description | Default |
|------------|-------------|---------|
| StartDate  | Search window start | 14 days ago |
| EndDate    | Search window end | Current time |
| MaxPages   | Maximum pages to retrieve | 10 |
| BatchSize  | Records per page | 500 |

## Analyzing Results

### Method 1: Console Output

Use `Format-LMLogAnomalyResults` for quick analysis with color-coded console output:

```powershell
# Direct pipeline
Find-LMLogAnomalyAlerts | Format-LMLogAnomalyResults

# Store results first
$results = Find-LMLogAnomalyAlerts
$results | Format-LMLogAnomalyResults
```

#### Console Output Includes:
- Alert Details:
  - Datasource name
  - Resource name
  - Instance details
  - Alert metadata
- Associated Logs:
  - Log ID and timestamp
  - Time difference
  - Sentiment score
  - Full message

### Method 2: HTML Report

Use `Export-LMLogAnomalyReport` for comprehensive analysis with visualizations:

```powershell
# Direct pipeline
Find-LMLogAnomalyAlerts | Export-LMLogAnomalyReport

# Store results first
$results = Find-LMLogAnomalyAlerts
$results | Export-LMLogAnomalyReport
```

#### Report Features:
- Summary Statistics
- Interactive Charts:
  - Alert severity distribution
  - Top 10 resources
  - Top 10 datasources
- Data Table:
  - Search/filter capabilities
  - Export options (CSV, Excel, PDF)
  - Color-coded severity
- Responsive Design

## Common Workflows

### Quick Analysis
```powershell
# Connect and search
Connect-LMAccount
Find-LMLogAnomalyAlerts | Format-LMLogAnomalyResults
```

### Detailed Report
```powershell
# Search last 7 days and generate report
$anomalies = Find-LMLogAnomalyAlerts -StartDate (Get-Date).AddDays(-7)
$anomalies | Export-LMLogAnomalyReport
```

### Multiple Analysis
```powershell
# Store results for multiple uses
$anomalies = Find-LMLogAnomalyAlerts

# Console review
$anomalies | Format-LMLogAnomalyResults

# Generate report
$anomalies | Export-LMLogAnomalyReport
```

## Best Practices

### When to Use Console Output
- Quick analysis
- Real-time troubleshooting
- Command-line workflows
- Initial data review

### When to Use HTML Report
- Detailed analysis
- Team sharing
- Documentation
- Data visualization needs
- Export requirements

### Performance Tips
1. Adjust `MaxPages` and `BatchSize` based on:
   - Environment size
   - Time range
   - Available resources

2. Store results in variable when:
   - Multiple analysis methods needed
   - Filtering/sorting required
   - Preserving point-in-time data

3. Use appropriate time ranges:
   - Shorter for quick analysis
   - Longer for trend analysis
   - Consider data volume

## Support

For issues or questions:
- GitHub: [Logic.Monitor.SE Repository](https://github.com/stevevillardi/Logic.Monitor.SE)
- PowerShell Gallery: [Logic.Monitor.SE Module](https://www.powershellgallery.com/packages/Logic.Monitor.SE)

