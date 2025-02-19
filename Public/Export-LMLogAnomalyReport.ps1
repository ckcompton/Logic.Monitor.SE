<#
.SYNOPSIS
    Generates a detailed HTML report of LogicMonitor log anomaly analysis results.

.DESCRIPTION
    This cmdlet creates an interactive HTML report from log anomaly analysis results. The report includes:
    - Summary statistics and visualizations
    - Severity distribution charts
    - Resource and datasource analysis
    - Detailed alert information with associated logs
    - Interactive data tables with search, filter, and export capabilities

    The report is generated using the PSWriteHTML module and includes responsive design elements
    for optimal viewing on different devices.

.PARAMETER InputObject
    Array of log anomaly results, typically from Find-LMLogAnomalyAlerts.
    Accepts pipeline input.

.OUTPUTS
    Generates an HTML file named "LogicMonitor-Anomaly-Report.html" containing:
    - Summary statistics
    - Interactive charts:
        * Alert severity distribution
        * Top 10 resources by alert count
        * Top 10 datasources by alert count
    - Detailed data table with:
        * Resource details
        * Alert information
        * Associated logs
        * Sentiment analysis
    - Export options (CSV, Excel, PDF)
    - Search and filtering capabilities

.EXAMPLE
    Find-LMLogAnomalyAlerts | Export-LMLogAnomalyReport
    
    Generates a report from the last 14 days of anomaly data.

.EXAMPLE
    $results = Find-LMLogAnomalyAlerts -StartDate (Get-Date).AddDays(-7)
    Export-LMLogAnomalyReport -InputObject $results
    
    Generates a report from the last 7 days of anomaly data using variable input.

.NOTES
    Requirements:
    - PSWriteHTML module must be installed
    - Modern web browser for viewing the report
    
    Features:
    - Responsive design
    - Interactive data visualization
    - Color-coded severity indicators
    - Sortable and searchable tables
    - Multiple export formats
    - Fixed headers for better navigation

.LINK
    Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
    PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE

.LINK
    PSWriteHTML: https://www.powershellgallery.com/packages/PSWriteHTML
#>

Function Export-LMLogAnomalyReport {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [Array]$InputObject
    )

    Begin {
        if (-not (Get-Module -Name PSWriteHTML -ListAvailable)) {
            Write-Error "PSWriteHTML module is required. Please install it using: Install-Module PSWriteHTML -Force"
            return
        }
        Import-Module PSWriteHTML
        $allAlerts = @()
    }

    Process {
        $allAlerts += $InputObject
    }

    End {
        $DateGenerated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $ReportPath = "LogicMonitor-Anomaly-Report.html"
        $Title = "LogicMonitor Anomaly Analysis Report"

        # Prepare the main table data
        $tableData = $allAlerts | ForEach-Object {
            [PSCustomObject]@{
                'Resource'          = $_.ResourceName
                'Instance'          = $_.InstanceName
                'Datapoint'         = $_.DatapointName
                'Datasource'        = $_.DatasourceName
                'AlertId'           = $_.AlertId
                'Alert Url'         = $_.AlertUrl
                'Alert Value'       = $_.AlertValue
                'Alert Type'        = $_.AlertType
                'Severity'          = $_.Severity
                'Timestamp'         = $_.AlertTimestamp.ToString('yyyy-MM-dd HH:mm:ss')
                'Log Count'         = $_.LogCount
                'Average Sentiment' = $_.AverageSentimentScore
                'Logs'              = if ($_.AssociatedLogs) {
                    $_.AssociatedLogs | ForEach-Object {
                        "`n[$($_.LogTimestamp.ToString('yyyy-MM-dd HH:mm:ss'))] [$($_.TimeDifferenceMinutes) minutes] [Score: $($_.SentimentScore)] $($_.LogMessage)"
                    } | Out-String
                } else { "No associated logs" }
            }
        }

        New-HTML -TitleText $Title -FilePath $ReportPath {
            # Add custom CSS for better layout
            New-HTMLHeader {
                New-HTMLText -Text "Report Generated: $DateGenerated" -Color Gray
            }


            # Summary Statistics Row
            New-HTMLSection -Invisible {
                New-HTMLPanel {
                    New-HTMLToast -Text 'Total Alerts with Log Anomalies' -TextHeader $allAlerts.Count -IconSolid exclamation-circle -BarColorLeft Blue -TextHeaderColor Blue
                }
                New-HTMLPanel {
                    New-HTMLToast -Text 'Total Logs Associated with Alerts' -TextHeader ($allAlerts | Measure-Object -Property LogCount -Sum | Select-Object -ExpandProperty Sum) -IconSolid exclamation-circle -BarColorLeft Green -TextHeaderColor Green
                }
                New-HTMLPanel {
                    New-HTMLToast -Text 'Warning Alerts' -TextHeader ($allAlerts | Where-Object Severity -EQ 2 | Measure-Object | Select-Object -ExpandProperty Count) -IconSolid exclamation-circle -BarColorLeft Red -TextHeaderColor Red
                }
                New-HTMLPanel {
                    New-HTMLToast -Text 'Error Alerts' -TextHeader ($allAlerts | Where-Object Severity -EQ 3 | Measure-Object | Select-Object -ExpandProperty Count) -IconSolid exclamation-circle -BarColorLeft Orange -TextHeaderColor Orange
                }
                New-HTMLPanel {
                    New-HTMLToast -Text 'Critical Alerts' -TextHeader ($allAlerts | Where-Object Severity -EQ 4 | Measure-Object | Select-Object -ExpandProperty Count) -IconSolid exclamation-circle -BarColorLeft Red -TextHeaderColor Red
                }
            }

            # Charts Row
            New-HTMLSection -Invisible {
                # Severity Distribution
                New-HTMLPanel -Width 100 {
                    New-HTMLChart {
                        New-ChartToolbar -Download
                        New-ChartLegend -Name 'Severity Distribution'
                        $severityCounts = $allAlerts | Group-Object Severity | Sort-Object Name
                        foreach ($severity in $severityCounts) {
                            $Name = $severity.Name
                            Switch ($severity.Name) {
                                2 { $Name = 'Warning'; $color = '#FFC100' } #yellow
                                3 { $Name = 'Error'; $color = '#FF7400' } #orange
                                4 { $Name = 'Critical'; $color = '#FF0000' } #red
                            }
                            New-ChartPie -Name $Name -Value $severity.Count -Color $color
                        }
                    } -Title 'Alert Severity Distribution'
                }

                # Resource Distribution
                New-HTMLPanel -Width 100 {
                    New-HTMLChart {
                        New-ChartToolbar -Download
                        New-ChartLegend -Name 'Top Resources'
                        $resourceCounts = $allAlerts | Group-Object ResourceName | Sort-Object Count -Descending | Select-Object -First 10
                        foreach ($resource in $resourceCounts) {
                            New-ChartBar -Name $resource.Name -Value $resource.Count
                        }
                    } -Title 'Top 10 Resources'
                }

                # Datasource Distribution
                New-HTMLPanel -Width 100 {
                    New-HTMLChart {
                        New-ChartToolbar -Download
                        New-ChartLegend -Name 'Top Datasources'
                        $datasourceCounts = $allAlerts | Group-Object DatasourceName | Sort-Object Count -Descending | Select-Object -First 10
                        foreach ($ds in $datasourceCounts) {
                            New-ChartDonut -Name $ds.Name -Value $ds.Count
                        }
                    } -Title 'Top 10 Datasources'
                }
            }
            
            # Alert Details Table
            New-HTMLSection -HeaderText 'Alert Details' {
                New-HTMLTable -DataTable $tableData -HideFooter:$false {
                    # Color coding for severity
                    New-TableCondition -Name 'Severity' -Value 2 -BackgroundColor '#FFC100' 
                    New-TableCondition -Name 'Severity' -Value 3 -BackgroundColor '#FF7400' 
                    New-TableCondition -Name 'Severity' -Value 4 -BackgroundColor '#FF0000' 

                } -Buttons @('searchPanes', 'pageLength', 'copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5') `
                    -FixedHeader -FixedFooter -DisablePaging -AutoSize 
            }

            New-HTMLFooter {
                New-HTMLText -Text @(
                    "Total Alerts: $($allAlerts.Count) | ",
                    "Average Sentiment Score: $([math]::Round(($allAlerts | Measure-Object -Property AverageSentimentScore -Average).Average, 2))"
                ) -Color Navy -FontSize 12
            }
        } -Online

        # Add informative messages about report generation
        Write-Host "`n===========================================" -ForegroundColor Cyan
        Write-Host "Report Generation Complete!" -ForegroundColor Green
        Write-Host "----------------------------------------"
        Write-Host "Report Details:" -ForegroundColor Yellow
        Write-Host "- Location: $((Get-Item $ReportPath).FullName)"
        Write-Host "- Generated: $DateGenerated"
        Write-Host "- Total Alerts: $($allAlerts.Count)"
        Write-Host "- Total Associated Logs: $($allAlerts | Measure-Object -Property LogCount -Sum | Select-Object -ExpandProperty Sum)"
        Write-Host "`nOpen the report in your web browser to view the interactive dashboard." -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan
    }
}