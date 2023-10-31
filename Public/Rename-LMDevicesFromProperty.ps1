Function Rename-LMDevicesFromProperty{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        $Device,

        $SourceProperty = "system.sysname",

        [ValidateSet("system","custom","auto")]
        $PropertyType = "system"
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