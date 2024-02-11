#Assumes csv with the headers ip,displayname,hostgroup,collectorid,description,property1,property2,property[n]....
Function Import-LMDevicesFromCSV {
    [CmdletBinding(DefaultParameterSetName="Import")]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [String]$FilePath,

        [Int]$CollectorId
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($(Get-LMAccountStatus).Valid) {
            $DeviceList = Import-Csv -Path $FilePath

            If($DeviceList){
                #Get property headers for adding to property hashtable
                $PropertyHeaders = ($DeviceList | Get-Member -MemberType NoteProperty).Name | Where-Object {$_ -notmatch "ip|displayname|hostgroup|collectorid|description"}
                
                #Loop through device list and add to portal
                Foreach($Device in $DeviceList){
                    $Properties = @{}
                    Foreach($Property in $PropertyHeaders){
                        $Properties.Add($Property,$Device."$Property")
                    }
                    Try{
                        $GroupId = (Get-LMDeviceGroup | Where-Object {$_.fullpath -eq $($Device.hostgroup)}).Id
                        If(!$GroupId){
                            $GroupPaths = $Device.hostgroup.Split("/")
                            Foreach($Path in $GroupPaths){
                                $GroupId = New-LMDeviceGroupFromPath -Path $Path -PreviousGroupId $GroupId
                            }
                        }
                        New-LMDevice -name $Device.ip -DisplayName $Device.displayname -Description $Device.description -PreferredCollectorId $Device.collectorid -HostGroupIds $GroupId -Properties $Properties -ErrorAction Stop
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
    End {}
}