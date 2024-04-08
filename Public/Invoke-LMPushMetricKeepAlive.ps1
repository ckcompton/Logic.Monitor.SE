<#
.SYNOPSIS
    This function invokes a keep-alive signal for Logic Monitor Push Metrics.

.DESCRIPTION
    The Invoke-LMPushMetricKeepAlive function sends a keep-alive signal to a device using Logic Monitor's Push Metrics. 
    It uses a device object passed as a parameter and has default values for various other parameters related to the datasource and datapoint.

.PARAMETER DeviceObject
    The device object for which the keep-alive signal is to be sent. This is a mandatory parameter and can be piped to the function.

.PARAMETER DatasourceGroupName
    The name of the datasource group. Defaults to "Host Status".

.PARAMETER DatasourceName
    The name of the datasource. Defaults to "PushMetricKeepAlive_PMv1".

.PARAMETER DatasourceDisplayName
    The display name of the datasource. Defaults to "PushMetric Keep Alive".

.PARAMETER InstanceName
    The name of the instance. Defaults to "PushMetric_Keep_Alive".

.PARAMETER DataPointName
    The name of the datapoint. Defaults to "KeepAlive".

.EXAMPLE
    Invoke-LMPushMetricKeepAlive -DeviceObject $Device

    This command sends a keep-alive signal to the device represented by the $Device object.

.INPUTS
    PSCustomObject. You can pipe a device object to Invoke-LMPushMetricKeepAlive.

.OUTPUTS
    The function does not return any output.

.NOTES
    The function throws an error if it fails to send the keep-alive signal.
#>
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