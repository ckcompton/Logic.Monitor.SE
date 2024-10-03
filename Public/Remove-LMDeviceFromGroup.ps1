<#
.SYNOPSIS
    Removes a Logic Monitor device from a specified group while preserving its other group memberships.

.DESCRIPTION
    The Remove-LMDeviceFromGroup function allows you to remove a Logic Monitor device from a specified group without affecting its membership in other groups. This function is useful for managing device organization within Logic Monitor.

.PARAMETER Id
    The ID of the Logic Monitor device to be removed from the group. This parameter is mandatory and can be piped from other cmdlets.

.PARAMETER GroupName
    The name of the group from which the device should be removed. This parameter is part of the "GroupName" parameter set and is mutually exclusive with GroupId.

.PARAMETER GroupId
    The ID of the group from which the device should be removed. This parameter is part of the "GroupId" parameter set and is mutually exclusive with GroupName.

.PARAMETER PassThru
    If specified, the function will return the updated device object after removing it from the group.

.EXAMPLE
    Remove-LMDeviceFromGroup -Id "123" -GroupName "Production Servers"
    This example removes the device with ID 123 from the group named "Production Servers".

.EXAMPLE
    Get-LMDevice -Name "webserver01" | Remove-LMDeviceFromGroup -GroupId "456" -PassThru
    This example retrieves a device named "webserver01" and pipes it to the Remove-LMDeviceFromGroup function, removing it from the group with ID 456 and returning the updated device object.

.NOTES
    This function requires an active Logic Monitor session. Use Connect-LMAccount to log in before running this function.
#>
Function Remove-LMDeviceFromGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory,ParameterSetName = "GroupName")]
        [String]$GroupName,

        [Parameter(Mandatory,ParameterSetName = "GroupId")]
        [String]$GroupId,

        [Switch]$PassThru
    )
    Begin{
        If($(Get-LMAccountStatus).Valid){}Else{Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.";return}
    }
    Process{

        #Get the device
        $Device = Get-LMDevice -Id $Id

        If($Device){
            #Get the device group id
            If($GroupName){
                $GroupId = (Get-LMDeviceGroup -Name $GroupName).id
            }
            
            #Split the hostgroupids into an array and remove the group id
            $HostGroupIds = ($Device.HostGroupIds -split "," | Where-Object {$_ -ne $GroupId}) -join ","

            Write-Host "Removing device $($Device.Name) from group $($GroupId)"
            $Result = Set-LMDevice -Id $Id -HostGroupIds $HostGroupIds

            #Return the result
            If($PassThru){
                $Result
                }
        }
        Else{
            Write-Error "Device $($Id) not found"
        }
    }
    End{}
}