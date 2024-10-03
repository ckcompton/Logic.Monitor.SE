<#
.SYNOPSIS
    Adds a Logic Monitor device to a specified group while preserving its existing group memberships.

.DESCRIPTION
    The Add-LMDeviceToGroup function allows you to add a Logic Monitor device to a specified group without removing it from its current groups. This function can be useful for organizing devices into multiple logical groups within Logic Monitor.

.PARAMETER Id
    The ID of the Logic Monitor device to be added to the group. This parameter is mandatory and can be piped from other cmdlets.

.PARAMETER GroupName
    The name of the group to which the device should be added. This parameter is part of the "GroupName" parameter set and is mutually exclusive with GroupId.

.PARAMETER GroupId
    The ID of the group to which the device should be added. This parameter is part of the "GroupId" parameter set and is mutually exclusive with GroupName.

.PARAMETER PassThru
    If specified, the function will return the updated device object after adding it to the group.

.EXAMPLE
    Add-LMDeviceToGroup -Id "123" -GroupName "Production Servers"
    This example adds the device with ID 123 to the group named "Production Servers".

.EXAMPLE
    Get-LMDevice -Name "webserver01" | Add-LMDeviceToGroup -GroupId "456" -PassThru
    This example retrieves a device named "webserver01" and pipes it to the Add-LMDeviceToGroup function, adding it to the group with ID 456 and returning the updated device object.

.NOTES
    This function requires an active Logic Monitor session. Use Connect-LMAccount to log in before running this function.
#>
Function Add-LMDeviceToGroup{
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
                
                If($($GroupId | Measure-Object).Count -gt 1){
                    Write-Error "Multiple device groups found for the specified name value: $GroupName. Please ensure value is unique and try again"
                    Return
                }
            }
            

            #Join the device group ids
            $HostGroupIds = $Device.HostGroupIds + "," + $GroupId
            #Add the device to the group

            Write-Host "Adding device $($Device.Name) to group $($GroupId)"
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