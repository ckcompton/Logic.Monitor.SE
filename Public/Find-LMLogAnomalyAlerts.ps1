<#
.SYNOPSIS
Generate list of alerts that have an associated log anomaly.

.DESCRIPTION
Generate list of alerts that have an associated log anomaly.

.EXAMPLE
Find-LMLogAnomalyAlerts

.NOTES
Must be connected to the portal you want to pull alerts from ahead of time.

.INPUTS
None. Does not accept pipeline input

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>

Function Find-LMLogAnomalyAlerts {
    [CmdletBinding()]
    Param(
        [DateTime]$StartDate = (Get-Date).AddDays(-14),
        [DateTime]$EndDate = (Get-Date)
    )
    
    Write-Information "Starting log anomaly alert matching process..."
    Write-Information "Date Range: $StartDate to $EndDate"

    If($(Get-LMAccountStatus).Valid){
        Write-Information "Account validation successful. Retrieving alerts and anomalies..."
        
        $Alerts = Get-LMAlert -StartDate $StartDate -EndDate $EndDate -ClearedAlerts $true
        Write-Information "Retrieved $($Alerts.Count) alerts"
        
        $Anomalies = Get-LMLogMessage -Query '_anomaly.type="never_before_seen"' -StartDate $(Get-Date).AddDays(-3) -EndDate $(Get-Date) -Async
        Write-Information "Retrieved $($Anomalies.Count) anomalies"

        If($Anomalies -and $Alerts){
            Write-Information "Starting matching process..."
            $matchedEvents = @()
            $processedCount = 0
            
            foreach ($log in $Anomalies) {
                $processedCount++
                if ($processedCount % 100 -eq 0) {
                    Write-Information "Processed $processedCount of $($Anomalies.Count) logs..."
                }

                # Convert timestamp to DateTime for comparison
                $logTime = [DateTimeOffset]::FromUnixTimeMilliseconds($log.timestamp).DateTime
                $logResourceId = $log._resource.id
                
                Write-Debug "Processing log ID: $($log.id) for resource $logResourceId at time $logTime"
                
                # Find matching alerts
                $matchingAlerts = $Alerts | Where-Object {
                    $alertResourceId = $_.monitorObjectId
                    $alertStartTime = [DateTimeOffset]::FromUnixTimeSeconds($_.startEpoch).DateTime
                    
                    # Check if IDs match and time is within ±30 minutes
                    ($logResourceId -eq $alertResourceId) -and 
                    ([Math]::Abs(($logTime - $alertStartTime).TotalMinutes) -le 30)
                }
                
                if ($matchingAlerts) {
                    Write-Information "Found $($matchingAlerts.Count) matching alert(s) for log ID: $($log.id)"
                    foreach ($alert in $matchingAlerts) {
                        $timeDiff = [Math]::Abs(($logTime - [DateTimeOffset]::FromUnixTimeSeconds($alert.startEpoch).DateTime).TotalMinutes)
                        Write-Debug "Matched with alert ID: $($alert.id), time difference: $timeDiff minutes"
                        
                        $matchedEvents += [PSCustomObject]@{
                            LogId = $log.id
                            AlertId = $alert.id
                            ResourceId = $logResourceId
                            LogTimestamp = $logTime
                            AlertTimestamp = [DateTimeOffset]::FromUnixTimeSeconds($alert.startEpoch).DateTime
                            TimeDifferenceMinutes = $timeDiff
                            LogMessage = $log.message
                            AlertType = $alert.type
                            Severity = $alert.severity
                        }
                    }
                }
                else {
                    Write-Debug "No matching alerts found for log ID: $($log.id)"
                }
            }
            
            # Return the matched events
            Write-Information "Matching process complete. Found $($matchedEvents.Count) total matches."
            if ($matchedEvents.Count -gt 0) {
                Write-Information "Returning matched events..."
                return $matchedEvents
            } else {
                Write-Information "No matching events found within the specified time window."
                return $null
            }
        }
        Else {
            Write-Information "No anomalies or alerts found for the given date range."
            Return
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}