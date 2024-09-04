<#
.SYNOPSIS
Exports cloud inventory information to CSV files based on the specified cloud type.

.DESCRIPTION
The Export-LMCloudInventory function exports cloud inventory information to CSV files based on the specified cloud type. It retrieves cloud accounts and their associated resource groups from LogicMonitor and exports the information to separate CSV files for each account.

.PARAMETER CloudType
Specifies the cloud type for which the inventory information should be exported. Valid values are 'AWS', 'Azure', 'GCP', and 'All'.

.PARAMETER FilePath
Specifies the directory path where the CSV files should be exported.

.EXAMPLE
Export-LMCloudInventory -CloudType AWS -FilePath "C:\Inventory"

This example exports the AWS cloud inventory information to CSV files in the "C:\Inventory" directory.

.EXAMPLE
Export-LMCloudInventory -CloudType All -FilePath "C:\Inventory"

This example exports the inventory information for all cloud types (AWS, Azure, GCP) to CSV files in the "C:\Inventory" directory.

.NOTES
This function requires the LogicMonitor PowerShell module to be installed and authenticated.
#>
Function Export-LMCloudInventory {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('AWS','Azure','GCP', 'All')]
        [string]$CloudType,

        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    Switch ($CloudType) {
        'AWS' {
            $cloudAccounts = Get-LMDeviceGroup -Filter "groupType -eq 'AWS/AwsRoot'"
        }
        'Azure' {
            $cloudAccounts = Get-LMDeviceGroup -Filter "groupType -eq 'Azure/AzureRoot'"
        }
        'GCP' {
            $cloudAccounts = Get-LMDeviceGroup -Filter "groupType -eq 'GCP/GcpRoot'"
        }
        default {
            $cloudAccounts = Get-LMDeviceGroup -Filter "groupType -eq 'AWS/AwsRoot' -or groupType -eq 'Azure/AzureRoot' -or groupType -eq 'GCP/GcpRoot'"
        }
    }

    $results = New-Object System.Collections.ArrayList

    #Check if the directory exists
    If(!(Test-Path $FilePath)){
        Write-Error "The directory $FilePath does not exist"
        return
    }

    foreach($cloudAccount in $cloudAccounts){
        $groups =Get-LMDeviceGroupGroups -id $cloudAccount.Id #id of cloud account resource group
        $accountResults = New-Object System.Collections.ArrayList
        foreach ($group in $groups) {
            $name = $group.name
            $type = $group.groupType
            $numOfHosts = $group.numOfHosts
            $azureRegionsInfo = $group.azureRegionsInfo | ConvertFrom-Json
            $awsRegionsInfo = $group.awsRegionsInfo | ConvertFrom-Json
            $gcpRegionsInfo = $group.gcpRegionsInfo | ConvertFrom-Json
        
            $Object = [PSCustomObject]@{
                AccountName = $cloudAccount.name
                ResourceName = $name
                ResourceType = $type
                NumOfHosts = $numOfHosts
            }
        
            If($azureRegionsInfo){
                foreach ($region in $($azureRegionsInfo | Get-Member -Type NoteProperty).Name) {
                    $Object | Add-Member -MemberType NoteProperty -Name $region -Value $azureRegionsInfo.$region
                }
            }
        
            If($awsRegionsInfo){
                foreach ($region in $($awsRegionsInfo | Get-Member -Type NoteProperty).Name) {
                    $Object | Add-Member -MemberType NoteProperty -Name $region -Value $awsRegionsInfo.$region
                }
            }

            If($gcpRegionsInfo){
                foreach ($region in $($gcpRegionsInfo | Get-Member -Type NoteProperty).Name) {
                    $Object | Add-Member -MemberType NoteProperty -Name $region -Value $gcpRegionsInfo.$region
                }
            }
        
            $accountResults.Add($Object) | Out-Null
        }
        $results.Add($accountResults) | Out-Null
    }
    #Exporting the results to CSV for each account in a separate file
    $results | ForEach-Object {$_ | Export-Csv $FilePath"/$($_.AccountName[0]).csv"; Write-Host "Exported $($_.AccountName[0]) to $FilePath/$($_.AccountName[0]).csv"}
}