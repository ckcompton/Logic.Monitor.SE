Function Invoke-LMPushMetricKeepAlive {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]
        $DeviceObject,

        $DatasourceGroupName = "Host Status",

        $DatasourceName = "PushMetricKeepAlive_PMv1",

        $DatasourceDisplayName = "PushMetric Keep Alive",

        $InstanceName = "PushMetric_Keep_Alive",

        $DataPointName = "KeepAlive"

    )

    Begin{
        #Check if we are logged in and have valid api creds
        If ($(Get-LMAccountStatus).Type -ne "Bearer") {
            Write-Error "Push Metrics API only officially only supports Bearer Token auth, please re-connect using a valid bearer token if you encounter errors with submission."
        }
        return
    }
    Process{
        $Datapoints = [System.Collections.Generic.List[object]]::New()
        $Datapoints.Add([PSCustomObject]@{
            Name = $DataPointName
            Description = "PushMetric datapoint to keep PMv1 devices active."
            Value = 1
        })

        $DatapointsArray = New-LMPushMetricDataPoint -Datapoints $Datapoints

        $InstanceArray = [System.Collections.Generic.List[object]]::New()
        $InstanceArray.Add($(New-LMPushMetricInstance -Datapoints $DatapointsArray -InstanceName $InstanceName -InstanceDisplayName $DatasourceName -InstanceDescription "PushMetric instance to keep PMv1 devices active."))

        #Submit PushMetric to portal
        $DeviceHostName = $DeviceObject.Name
        $DeviceDisplayName = $DeviceObject.DisplayName
        $DatasourceGroup =   $DatasourceGroupName
        $DatasourceDisplayName = $DatasourceDisplayName
        $DatasourceName = $DatasourceName
        $ResourceIds = @{"system.hostname"=$DeviceHostName;"system.displayname"=$DeviceDisplayName}

        Write-Host "Submitting PushMetric to ingest for $DeviceHostName ($DeviceDisplayName)."
        $Result = Send-LMPushMetric -Instances $InstanceArray -DatasourceGroup $DatasourceGroup -DatasourceDisplayName $DatasourceDisplayName -DatasourceName $DatasourceName -ResourceIds $ResourceIds -NewResourceHostName $DeviceHostName

        Write-Host "PushMetric submitted with status: $($Result.message)  @($($Result.timestamp))"
    }
    End{}
}