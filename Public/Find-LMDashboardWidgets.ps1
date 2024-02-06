Function Find-LMDashboardWidgets{
    Param(
        [Parameter(Mandatory)]
        [String]$DeprecatedModule ,

        [String]$GroupPathSearchString = "*"
    )

    $Results = New-Object System.Collections.ArrayList
    $Dashboards = Get-LMDashboard | Where-Object {$_.groupFullPath -like "$GroupPathSearchString"}
    Foreach($Dashboard in $Dashboards){
        $Widgets = (Get-LMDashboardWidget -DashboardId $Dashboard.Id).graphInfo.datapoints | Where-Object {$_.dataSourceFullName -like "*$DeprecatedModule*"}
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
    }

    Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeprecatedDashboardWidgets" )
}