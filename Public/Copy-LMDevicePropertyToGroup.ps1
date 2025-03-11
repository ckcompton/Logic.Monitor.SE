<#
.SYNOPSIS
    Copies device properties from a source device to target device groups.

.DESCRIPTION
    The Copy-LMDevicePropertyToGroup function copies specified properties from a source device to one or more target device groups.
    The source device can be randomly selected from a group or explicitly specified. Properties are copied to the target groups while
    preserving other existing group properties.

.PARAMETER SourceDeviceId
    The ID of the source device to copy properties from. This parameter is part of the "SourceDevice" parameter set.

.PARAMETER SourceGroupId
    The ID of the source group to randomly select a device from. This parameter is part of the "SourceGroup" parameter set.

.PARAMETER TargetGroupId
    The ID of the target group(s) to copy properties to. Multiple group IDs can be specified.

.PARAMETER PropertyNames
    Array of property names to copy. These can be custom or system properties.

.PARAMETER PassThru
    If specified, returns the updated device group objects.

.EXAMPLE
    Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456 -PropertyNames "location","department"
    Copies the location and department properties from device 123 to group 456.

.EXAMPLE
    Copy-LMDevicePropertyToGroup -SourceGroupId 789 -TargetGroupId 456,457 -PropertyNames "location" -PassThru
    Randomly selects a device from group 789 and copies its location property to groups 456 and 457, returning the updated groups.

.NOTES
    Requires an active Logic Monitor session. Use Connect-LMAccount to log in before running this function.

.LINK
    Module repo: https://github.com/stevevillardi/Logic.Monitor.SE
#>
Function Copy-LMDevicePropertyToGroup {
    [CmdletBinding(DefaultParameterSetName="SourceDevice")]
    Param(
        [Parameter(Mandatory,ParameterSetName="SourceDevice",ValueFromPipelineByPropertyName)]
        [String]$SourceDeviceId,

        [Parameter(Mandatory,ParameterSetName="SourceGroup")]
        [String]$SourceGroupId,

        [Parameter(Mandatory)]
        [String[]]$TargetGroupId,

        [Parameter(Mandatory)]
        [String[]]$PropertyNames,

        [Switch]$PassThru
    )

    Begin {
        If($(Get-LMAccountStatus).Valid){}
        Else{
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }
    }

    Process {
        Try {
            # Get source device either directly or from group
            If($PSCmdlet.ParameterSetName -eq "SourceDevice") {
                $sourceDevice = Get-LMDevice -Id $SourceDeviceId
                If(!$sourceDevice) {
                    Write-Error "Source device with ID $SourceDeviceId not found"
                    return
                }
            }
            Else {
                $devices = Get-LMDeviceGroupDevices -Id $SourceGroupId
                If(!$devices) {
                    Write-Error "No devices found in source group with ID $SourceGroupId"
                    return
                }
                $sourceDevice = $devices | Get-Random
            }

            # Initialize results array if PassThru specified
            $results = New-Object System.Collections.ArrayList

            # Process each target group
            Foreach($groupId in $TargetGroupId) {
                $group = Get-LMDeviceGroup -Id $groupId
                If(!$group) {
                    Write-Warning "Target group with ID $groupId not found, skipping..."
                    continue
                }

                # Build properties hashtable
                $propertiesToCopy = @{}
                Foreach($propName in $PropertyNames) {
                    # Check custom properties
                    $propValue = $null
                    If($sourceDevice.customProperties.name -contains $propName) {
                        $propValue = $sourceDevice.customProperties[$sourceDevice.customProperties.name.IndexOf($propName)].value
                    }
                    If($propValue) {
                        $propertiesToCopy[$propName] = $propValue
                    }
                    Else {
                        Write-Warning "Property $propName not found on source device $($sourceDevice.id), skipping..."
                    }
                }

                If($propertiesToCopy.Count -gt 0) {
                    Write-Host "Copying properties to group $($group.name) (ID: $groupId)"
                    $updatedGroup = Set-LMDeviceGroup -Id $groupId -Properties $propertiesToCopy
                    If($PassThru) {
                        $results.Add($updatedGroup) | Out-Null
                    }
                }
            }
        }
        Catch {
            Write-Error "Error copying properties: $_"
        }
    }

    End {
        If($PassThru) {
            Return $results
        }
    }
}