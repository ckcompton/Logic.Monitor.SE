Function Find-LMDashboardWidgets{
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [String]$DatasourceName,

        [String]$GroupPathSearchString = "*"
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($(Get-LMAccountStatus).Valid) {
            $Results = New-Object System.Collections.ArrayList
            $Dashboards = Get-LMDashboard | Where-Object {$_.groupFullPath -like "$GroupPathSearchString"}

            $i = 0
            $DashCount = ($Dashboards | Measure-Object).Count
            Foreach($Dashboard in $Dashboards){
                Write-Progress -Activity "Processing Dashboard: $($Dashboard.name)" -Status "$([Math]::Floor($($i/$DashCount*100)))% Completed" -PercentComplete $($i/$DashCount*100) -Id 0
                $Widgets = (Get-LMDashboardWidget -DashboardId $Dashboard.Id).graphInfo.datapoints | Where-Object {$_.dataSourceFullName -like "*$DatasourceName*"}
                If($Widgets){
                    $Widgets | ForEach-Object {$Results.Add([PSCustomObject]@{
                        dataSourceId = $_.dataSourceId
                        dataSourceFullName = $_.dataSourceFullName
                        dataPointId = $_.dataPointId
                        dataPointName = $_.dataPointName
                        widgetId = $_.id
                        widgetName = $_.name
                        dashboardId = $Dashboard.id
                        dashboardName = $Dashboard.name
                        dashboardPath = $Dashboard.groupFullPath
                    }) | Out-Null}
                }
                $i++
            }

            Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeprecatedDashboardWidgets" )
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}