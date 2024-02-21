<#
.SYNOPSIS
Rebuild orginal out of box dyanmic resource groups.

.DESCRIPTION
Rebuild orginal out of box dyanmic resource groups.

.EXAMPLE
Import-LMDefaultDynamicGroups -ParentGroupId 1 -RootGroupName "Devices by Type"

.NOTES
You can specify a different -RootGroupName and -ParentGroupId if you want to deploy under a different location/name.

.INPUTS
None. Does not accept pipeline input.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function Import-LMDefaultDynamicGroups{
    Param(
        [String]$ParentGroupId = "1",

        [String]$RootGroupName = "Devices by Type"
    )
    Begin {}
    Process {
        Function New-LMDefaultDynamicGroup {
            Param(
                [String]$ParentGroupId = "1",

                [String]$GroupName,

                [String]$AppliesTo
            )

            If(!$(Get-LMDeviceGroup -Filter "name -eq '$GroupName' -and parentId -eq '$ParentGroupId'")){
                $NewGroup = New-LMDeviceGroup -Name $GroupName -ParentGroupId $ParentGroupId -AppliesTo $AppliesTo
                If($NewGroup){
                    Write-Host "[INFO]: Created new dynamic group: $($GroupName)"
                }
            }
            Else{
                Write-Host "[INFO]: Dynamic group: $($GroupName) already exists, skipping creation" -ForegroundColor Gray
            }
            
            Return $NewGroup
        }
        
        If ($(Get-LMAccountStatus).Valid) {
            #Generate hastable of new dynamic groups to create
            $DynamicGroupList = @{
                "Collectors" = 'isCollectorDevice()'
                "Minimal Monitoring" = 'system.sysinfo == "" && system.sysoid == "" && isDevice() && !(system.virtualization) && (monitoring != "basic") && !(system.categories)'
                "Windows Servers" = 'isWindows() && system.displayname !~ "collector"'
                "SQL Servers" = 'hasCategory("MSSQL")'
                "Linux Servers" = 'isLinux() && system.devicetype != "8"'
                "Hyper-V" = 'hasCategory("HyperV")'
                "VMware ESXi Hosts" = 'system.virtualization =~ "host"'
                "VMware vCenters" = 'system.virtualization =~ "vcenter"'
                "XenServer" = 'system.virtualization =~ "Xen"'
                "Storage" = 'isStorage()'
                "NetApp" = 'hasCategory("NetApp")'
                "EMC" = 'hasCategory("EMC")'
            }
            
            $DevicesByType = Get-LMDeviceGroup -Filter "name -eq '$RootGroupName' -and parentId -eq '1'"
            If(!$DevicesByType){
                $DevicesByType = New-LMDefaultDynamicGroup -GroupName $RootGroupName -AppliesTo $Null -ParentGroupId $ParentGroupId
            }
            Else{
                Write-Host "[INFO]: Dynamic group: $RootGroupName already exists, skipping creation" -ForegroundColor Gray
            }

            Write-Host "[INFO]: Creating additional default dynamic groups"
            $Results = New-Object System.Collections.ArrayList
            Foreach($Group in $DynamicGroupList.GetEnumerator()){
                $NewGroup = New-LMDefaultDynamicGroup -GroupName $Group.Name -AppliesTo $Group.Value -ParentGroupId $DevicesByType.Id
                $Results.Add($NewGroup) | Out-Null
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {
        Return $Results
    }
}