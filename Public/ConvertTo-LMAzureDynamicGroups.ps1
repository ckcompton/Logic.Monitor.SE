<#
.SYNOPSIS
Create a series of dynamic groups for each azure subscription in a portal

.DESCRIPTION
Create a series of dynamic groups for each azure subscription in a portal

.EXAMPLE
ConvertTo-LMAzureDynamicGroups -AzureRootGroupId 85

.NOTES
Created groups will be placed in a main group called Azure Resources by Subscription in the parent group specified by the -ParentGroupId parameter

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function ConvertTo-LMAzureDynamicGroups{
    Param(
        [Parameter(Mandatory)]
        [String]$AzureRootGroupId,
        
        [String]$ParentGroupId = 1
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($(Get-LMAccountStatus).Valid) {
            #Get non-empty LM cloud groups
            Write-Progress -Activity "Processing Azure Account, gathering details and devices" -Status "0% Completed" -PercentComplete 0
            $RootGroup = Get-LMDeviceGroup -Id $AzureRootGroupId
            #$AzureGroups = Get-LMDeviceGroupGroups -Id $AzureRootGroupId | Where-Object {$_.numOfDirectDevices -gt 0}
            $AzureDevices = Get-LMDevice -Filter "deviceType -eq '4'" | Where-Object {$_.systemProperties.name -eq "system.azure.subscriptionname" -and $_.systemProperties.name -eq 'system.azure.subscriptionid'}
            $WorkingSet = New-Object System.Collections.ArrayList
            Foreach ($Device in $AzureDevices){
                $WorkingSet.Add([PSCustomObject]@{
                    SubName = $Device.systemProperties.value[$Device.systemProperties.name.indexOf("system.azure.subscriptionname")]
                    SubId = $Device.systemProperties.value[$Device.systemProperties.name.indexOf("system.azure.subscriptionid")]
                    SubCat = $Device.systemProperties.value[$Device.systemProperties.name.indexOf("system.cloud.category")]
                }) | Out-Null
            }

            $SubGroups = ($WorkingSet | Group-Object -Property SubName,SubId)
            $CatGroups = ($WorkingSet | Group-Object -Property SubName,SubId,SubCat)

            $i = 0
            $SubGroupsCount = ($SubGroups | Measure-Object).Count

            If($SubGroups){
                #Create Top Level Folder
                $RootGroup = Get-LMDeviceGroup -Name "Azure Resources by Subscription"
                If(!$RootGroup){
                    $RootGroup = New-LMDeviceGroup -Name "Azure Resources by Subscription" -ParentGroupId $ParentGroupId
                }

                #Create each sub folder under root
                Foreach($Sub in $SubGroups){
                    $Name = $Sub.Group[0].SubName
                    $Id = $Sub.Group[0].SubId
                    
                    Write-Progress -Activity "Processing Subscription: $Name" -Status "$([Math]::Floor($($i/$SubGroupsCount*100)))% Completed - $i of $SubGroupsCount subscription groups created" -PercentComplete $($i/$SubGroupsCount*100) -Id 0
                    
                    #Create Top level static group
                    $SubGroup = Get-LMDeviceGroup -Name $Name | Where-Object {$_.parentId -eq $RootGroup.Id}
                    If(!$SubGroup){
                        $SubGroup = New-LMDeviceGroup -Name $Name -Description "Resource for subscription id: $Id" -ParentGroupId $RootGroup.Id
                    }
                    
                    $SubCatGroups = $CatGroups | Where-Object {$_.Name -like "*$Id*"}
                    
                    $j = 0
                    $SubCatGroupsCount = ($SubCatGroups | Measure-Object).Count

                    #Create category groups under sub level group
                    Foreach ($Cat in $SubCatGroups){
                        Write-Progress -Activity "Processing subscription category groups" -ParentId 0 -Id 1 -Status "$([Math]::Floor($j/$SubCatGroupsCount*100))% Completed - $j of $SubCatGroupsCount category groups created" -PercentComplete $($j/$SubCatGroupsCount*100)
                        $CatName = $Cat.Group[0].SubCat
                        $GroupName = $CatName.Replace("Azure/","")
                        $GroupAppliesTo = "system.azure.subscriptionid == `"$Id`" && system.cloud.category == `"$CatName`""
                        New-LMDeviceGroup -Name $GroupName -Description "Resources for azure subscription $Name matching category $CatName" -AppliesTo $GroupAppliesTo -ParentGroupId $SubGroup.Id
                        $j++
                    }

                    $i++
                }
            }
        }
        Else{
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End{}
}