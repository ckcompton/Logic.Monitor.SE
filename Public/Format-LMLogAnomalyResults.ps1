<#
.SYNOPSIS
    Formats and displays LogicMonitor log anomaly detection results in a human-readable console output.

.DESCRIPTION
    This function takes LogicMonitor log anomaly results and presents them in a structured, color-coded format
    in the console. It displays alert details and associated logs with their metadata and messages.

.PARAMETER Results
    Collection of log anomaly result objects that will be formatted and displayed.
    Accepts pipeline input.

.OUTPUTS
    For each result, displays:
    - Alert Details:
        * Datasource name
        * Resource name
        * Instance details
        * Alert metadata (ID, type, severity, timestamp)
        * Log statistics (count, sentiment scores)
    
    - Associated Logs:
        * Log ID
        * Timestamp
        * Time difference in minutes
        * Sentiment score
        * Full log message

.EXAMPLE
    $anomalyResults | Format-LMLogAnomalyResults

.NOTES
    Output is color-coded:
    - Cyan: Section separators
    - Yellow: Section headers
    - Gray: Log messages
    - White: All other output
#>

Function Format-LMLogAnomalyResults {
    Param(
        [Parameter(ValueFromPipeline=$true)]
        $Results
    )
    Process {
        foreach ($result in $Results) {
            Write-Host "`n===========================================" -ForegroundColor Cyan
            Write-Host "Alert Details:" -ForegroundColor Yellow
            Write-Host "Datasource: $($result.DatasourceName)"
            Write-Host "Resource: $($result.ResourceName)"
            Write-Host "Instance: $($result.InstanceName)"
            Write-Host "Description: $($result.InstanceDescription)"
            Write-Host "Alert ID: $($result.AlertId)"
            Write-Host "Type: $($result.AlertType)"
            Write-Host "Severity: $($result.Severity)"
            Write-Host "Timestamp: $($result.AlertTimestamp)"
            Write-Host "Associated Logs: $($result.LogCount)"
            Write-Host "Total Sentiment Score: $($result.TotalSentimentScore)"
            Write-Host "Average Sentiment Score: $($result.AverageSentimentScore)"
            
            Write-Host "`nAssociated Logs:" -ForegroundColor Yellow
            foreach ($log in $result.AssociatedLogs) {
                Write-Host "`n-------------------------------------------"
                Write-Host "Log ID: $($log.LogId)"
                Write-Host "Timestamp: $($log.LogTimestamp)"
                Write-Host "Time Difference: $($log.TimeDifferenceMinutes) minutes"
                Write-Host "Sentiment Score: $($log.SentimentScore)"
                Write-Host "Message:"
                Write-Host $log.LogMessage -ForegroundColor Gray
            }
        }
    }
}