<#
.SYNOPSIS
    This function searches for a specified pattern in the configuration backups of Logic Monitor devices.

.DESCRIPTION
    The Search-LMDeviceConfigBackup function takes an array of configuration backups and a search pattern as input. 
    It searches for the pattern in the configuration content of each device and returns the results.

.PARAMETER ConfigBackups
    An array of configuration backups for the devices. This is a mandatory parameter and can be piped to the function.

.PARAMETER SearchPattern
    The pattern to search for in the configuration backups. This is a mandatory parameter.

.EXAMPLE
    Search-LMDeviceConfigBackup -ConfigBackups $ConfigBackups -SearchPattern "hostname"

    This command searches for the pattern "hostname" in the configuration backups represented by the $ConfigBackups array.

.INPUTS
    System.Object[]. You can pipe an array of configuration backups to Search-LMDeviceConfigBackup.

.OUTPUTS
    The function returns an array of custom objects. Each object represents a search result and contains the device display name, 
    the device poll timestamp in UTC, the device instance name, the configuration version, the line number where the match was found, 
    and the content of the match. If no match is found for a device, the line number and content are set to "No Match".

.NOTES
    The function writes a message to the host for each device, indicating the number of search results found.
#>
Function Search-LMDeviceConfigBackup {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Object[]]$ConfigBackups,

        [Parameter(Mandatory)]
        [Regex]$SearchPattern
    )
    Begin{}
    Process{
        $Results = @()
        Foreach ($device in $ConfigBackups){
            $SearchResults = $device.configContent.Split("`n") | Select-String -Pattern $SearchPattern -Context 0,0 | Select-Object Line,LineNumber
            If($SearchResults){
                $ResultCount = ($SearchResults | Measure-Object).Count
                Write-Host "Found $ResultCount search results matching pattern ($SearchPattern) for device: $($device.deviceDisplayName)"
                Foreach($Match in $SearchResults){
                    $Results += [PSCustomObject]@{
                        deviceDisplayName = $device.deviceDisplayName
                        devicePollTimestampUTC = $device.devicePollTimestampUTC
                        deviceInstanceName = $device.deviceInstanceName
                        configVersion = $device.deviceConfigVersion
                        configMatchLine = $Match.LineNumber
                        configMatchContent = $Match.Line
                    }
                }
            }
            Else{
                #Add entry noting pattern not found for device
                $Results += [PSCustomObject]@{
                    deviceDisplayName = $device.deviceDisplayName
                    devicePollTimestampUTC = $device.devicePollTimestampUTC
                    deviceInstanceName = $device.deviceInstanceName
                    configVersion = $device.deviceConfigVersion
                    configMatchLine = "No Match"
                    configMatchContent = "No Match"
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ConfigSearchResults" )
    }
    End{}
}