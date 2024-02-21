<#
.SYNOPSIS
Imports list of devices based on specified CSV file
.DESCRIPTION
Imports list of devices based on specified CSV file. This will also create any groups specified in the hostgroups field so they are not required to exist ahead of import. Hostgroup should be the intended full path to the device. You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

.EXAMPLE
Import-LMDevicesFromCSV -FilePath ./ImportList.csv -PassThru -CollectorId 8

.NOTES
Assumes csv with the headers ip,displayname,hostgroup,collectorid,description,property1,property2,property[n]. Ip, displayname and collectorid are the only required fields.

.INPUTS
None. Does not accept pipeline input.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function Import-LMDevicesFromCSV {
    [CmdletBinding(DefaultParameterSetName="Import")]
    param (
        [Parameter(Mandatory=$true, ParameterSetName="Import")]
        [ValidateScript({Test-Path $_})]
        [String]$FilePath,
        
        [Parameter(ParameterSetName="Sample")]
        [Switch]$GenerateExampleCSV,
        
        [Parameter(ParameterSetName="Import")]
        [Switch]$PassThru,
        
        [Parameter(ParameterSetName="Import")]
        [Int]$CollectorId
    )
    #Check if we are logged in and have valid api creds
    Begin {
        $Results = New-Object System.Collections.ArrayList
    }
    Process {
        If($GenerateExampleCSV){
            $SampleCSV = ("ip,displayname,hostgroup,collectorid,description,property.name1,property.name2").Split(",")

            [PSCustomObject]@{
                $SampleCSV[0]="192.168.1.1"
                $SampleCSV[1]="SampleDeviceName"
                $SampleCSV[2]="Full/Path/To/Resource"
                $SampleCSV[3]="8"
                $SampleCSV[4]="My sample device"
                $SampleCSV[5]="property value 1"
                $SampleCSV[6]="property value 2"
            } | Export-Csv "SampleLMDeviceImportCSV.csv"  -Force -NoTypeInformation

            Return
        }
        If ($(Get-LMAccountStatus).Valid) {
            $DeviceList = Import-Csv -Path $FilePath

            If($DeviceList){
                #Get property headers for adding to property hashtable
                $PropertyHeaders = ($DeviceList | Get-Member -MemberType NoteProperty).Name | Where-Object {$_ -notmatch "ip|displayname|hostgroup|collectorid|description"}
                
                $i = 0
                $DeviceCount = ($DeviceList | Measure-Object).Count - 1

                #Loop through device list and add to portal
                Foreach($Device in $DeviceList){
                    Write-Progress -Activity "Processing Device Import: $($Device.displayname)" -Status "$([Math]::Floor($($i/$DeviceCount*100)))% Completed" -PercentComplete $($i/$DeviceCount*100) -Id 0
                    $Properties = @{}
                    Foreach($Property in $PropertyHeaders){
                        $Properties.Add($Property,$Device."$Property")
                    }
                    Try{
                        $GroupId = (Get-LMDeviceGroup | Where-Object {$_.fullpath -eq $($Device.hostgroup)}).Id
                        If(!$GroupId){
                            $GroupPaths = $Device.hostgroup.Split("/")
                            $j = 0
                            $GroupPathsCount = ($GroupPaths | Measure-Object).Count - 1
                            Foreach($Path in $GroupPaths){
                                Write-Progress -Activity "Processing Group Creation: $($Device.hostgroup)" -Status "$([Math]::Floor($($j/$GroupPathsCount*100)))% Completed" -PercentComplete $($j/$GroupPathsCount*100) -ParentId 0 -Id 1
                                $GroupId = New-LMDeviceGroupFromPath -Path $Path -PreviousGroupId $GroupId
                                $j++
                            }
                        }
                        $Device = New-LMDevice -name $Device.ip -DisplayName $Device.displayname -Description $Device.description -PreferredCollectorId $Device.collectorid -HostGroupIds $GroupId -Properties $Properties -ErrorAction Stop
                        $Results.Add($Device) | Out-Null
                        $i++
                    }
                    Catch{
                        Write-Error "[ERROR]: Unable to add device $($Device.displayname) to portal: $_"
                    }
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {
        Return $(If($PassThru){$Results}Else{$Null})
    }
}