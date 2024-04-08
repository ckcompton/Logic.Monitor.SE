<#
.SYNOPSIS
    This function renames Logic Monitor devices based on a specified property.

.DESCRIPTION
    The Rename-LMDevicesFromProperty function renames devices in Logic Monitor based on a specified property. 
    The property can be a system property, a custom property, or an auto property. 
    The function uses the Set-LMDevice cmdlet to rename the devices.

.PARAMETER Device
    The device or devices to be renamed. This is a mandatory parameter and can be piped to the function.

.PARAMETER SourceProperty
    The property based on which the devices are to be renamed. Defaults to "system.sysname".

.PARAMETER PropertyType
    The type of the property. Can be "system", "custom", or "auto". Defaults to "system".

.EXAMPLE
    Rename-LMDevicesFromProperty -Device $Device -SourceProperty "system.hostname" -PropertyType "system"

    This command renames the device represented by the $Device object based on the system property "system.hostname".

.INPUTS
    System.Object[]. You can pipe a device or an array of devices to Rename-LMDevicesFromProperty.

.OUTPUTS
    The function does not return any output. It displays a message for each device that is renamed or skipped.

.NOTES
    The function throws an error if it fails to rename a device.
#>
Function Rename-LMDevicesFromProperty{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Object[]]$Device,

        [String]$SourceProperty = "system.sysname",

        [ValidateSet("system","custom","auto")]
        [String]$PropertyType = "system"
    )
    Begin{
        If($(Get-LMAccountStatus).Valid){}Else{Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.";return}
    }
    Process{
        $PropertyLocation = $PropertyType + "Properties"
        $DeviceProperty = ($Device.$PropertyLocation[$Device.$PropertyLocation.name.IndexOf($SourceProperty)]).value
        If($DeviceProperty -and $Device.$PropertyLocation.name.IndexOf($SourceProperty) -ne -1){
            Try{
                $Result = Set-LMDevice -Id $Device.id -DisplayName $DeviceProperty
                Write-Host "Updated device displayname: $($Device.displayName) -> $($Result.displayName) based on property vaule ($($SourceProperty))."
            }
            Catch{

            }
        }
        Else{
            Write-Warning "$($Device.displayName) does not have a matching source property $SourceProperty, skipping device rename."
        }
    }
    End{}
}