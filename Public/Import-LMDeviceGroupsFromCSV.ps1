<#
.SYNOPSIS
Imports list of devices based on specified CSV file.

.DESCRIPTION
Imports list of devices based on specified CSV file. This will also create any groups specified in the hostgroups field so they are not required to exist ahead of import. Hostgroup should be the intended full path to the device. You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

.EXAMPLE
Import-LMDeviceGroupsFromCSV -FilePath ./ImportList.csv -PassThru

.NOTES
Assumes csv with the headers name,fullpath,description,appliesTo,property1,property2,property[n]. Name and fullpath are the only required fields.

.INPUTS
None. Does not accept pipeline input.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function Import-LMDeviceGroupsFromCSV {
    [CmdletBinding(DefaultParameterSetName="Import")]
    param (
        [Parameter(Mandatory=$true, ParameterSetName="Import")]
        [ValidateScript({Test-Path $_})]
        [String]$FilePath,
        
        [Parameter(ParameterSetName="Sample")]
        [Switch]$GenerateExampleCSV,
        
        [Parameter(ParameterSetName="Import")]
        [Switch]$PassThru
    )

    #Check if we are logged in and have valid api creds
    Begin {
        $Results = New-Object System.Collections.ArrayList
    }
    Process {
        If($GenerateExampleCSV){
            $SampleCSV = ("name,fullpath,description,appliesTo,property.name1,property.name2").Split(",")

            $SampleContent = New-Object System.Collections.ArrayList
            $SampleContent.Add([PSCustomObject]@{
                $SampleCSV[0]="California"
                $SampleCSV[1]="Locations/North America"
                $SampleCSV[2]="My sample device group for CA"
                $SampleCSV[3]='system.displayName =~ "CA-*" && isDevice()'
                $SampleCSV[4]="property value 1"
                $SampleCSV[5]="property value 2"
            }) | Out-Null
            $SampleContent.Add([PSCustomObject]@{
                $SampleCSV[0]="New York"
                $SampleCSV[1]="Locations/North America"
                $SampleCSV[2]="My sample device group for NY"
                $SampleCSV[3]='system.displayName =~ "NY-*" && isDevice()'
                $SampleCSV[4]="property value 1"
                $SampleCSV[5]="property value 2"
            }) | Out-Null
            $SampleContent.Add([PSCustomObject]@{
                $SampleCSV[0]="London"
                $SampleCSV[1]="Locations/Europe"
                $SampleCSV[2]="My sample device group for London"
                $SampleCSV[3]='system.displayName =~ "LONDON-*" && isDevice()'
                $SampleCSV[4]="property value 1"
                $SampleCSV[5]="property value 2"
            }) | Out-Null

            $SampleContent | Export-Csv "SampleLMDeviceGroupImportCSV.csv"  -Force -NoTypeInformation

            Return
        }
        If ($(Get-LMAccountStatus).Valid) {
            $GroupList = Import-Csv -Path $FilePath

            If($GroupList){
                #Get property headers for adding to property hashtable
                $PropertyHeaders = ($GroupList | Get-Member -MemberType NoteProperty).Name | Where-Object {$_ -notmatch "name|fullpath|description|appliesTo"}
                
                $i = 0
                $GroupCount = ($GroupList | Measure-Object).Count - 1

                #Loop through device list and add to portal
                Foreach($DeviceGroup in $GroupList){
                    Write-Progress -Activity "Processing Group Import: $($DeviceGroup.name)" -Status "$([Math]::Floor($($i/$GroupCount*100)))% Completed" -PercentComplete $($i/$GroupCount*100) -Id 0
                    $Properties = @{}
                    Foreach($Property in $PropertyHeaders){
                        $Properties.Add($Property,$DeviceGroup."$Property")
                    }
                    Try{
                        $GroupId = (Get-LMDeviceGroup | Where-Object {$_.fullpath -eq $($DeviceGroup.fullpath)}).Id
                        If(!$GroupId){
                            $GroupPaths = $DeviceGroup.fullpath.Split("/")
                            $j = 0
                            $GroupPathsCount = ($GroupPaths | Measure-Object).Count - 1
                            Foreach($Path in $GroupPaths){
                                Write-Progress -Activity "Processing Parent Group Creation: $($DeviceGroup.fullpath)" -Status "$([Math]::Floor($($j/$GroupPathsCount*100)))% Completed" -PercentComplete $($j/$GroupPathsCount*100) -ParentId 0 -Id 1
                                $GroupId = New-LMDeviceGroupFromPath -Path $Path -PreviousGroupId $GroupId
                                $j++
                            }
                        }
                        $DeviceGroup = New-LMDeviceGroup -name $DeviceGroup.name -Description $DeviceGroup.description -ParentGroupId $GroupId -Properties $Properties -AppliesTo $DeviceGroup.appliesTo -ErrorAction Stop
                        $Results.Add($DeviceGroup) | Out-Null
                        $i++
                    }
                    Catch{
                        Write-Error "[ERROR]: Unable to add device $($DeviceGroup.name) to portal: $_"
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