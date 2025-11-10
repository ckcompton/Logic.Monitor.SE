<#
.SYNOPSIS
Updates AWS Cloud discovery settings for specified AWS accounts in LogicMonitor.

.DESCRIPTION
This function updates AWS Cloud discovery settings such as monitored regions, automatic deletion policies, and alerting preferences for AWS services within LogicMonitor. It interacts with the LogicMonitor REST API to retrieve and modify the discovery configuration for AWS accounts. The function supports updating a single AWS account by AccountId or multiple accounts by importing AccountIds from a CSV file.

.PARAMETER AccountId
The AWS account ID for which to update discovery settings. Required if CsvPath is not specified.

.PARAMETER ServiceName
The AWS service name (e.g., "EC2") whose discovery settings are to be updated.

.PARAMETER Regions
An array of AWS regions (e.g., "us-east-1","us-east-2") to specify which regions should be monitored.

.PARAMETER CsvPath
Path to a CSV file containing multiple AWS AccountIds to update in bulk. The CSV must have an "AccountId" column.

.PARAMETER AutoDelete
Switch to enable or disable automatic deletion of terminated AWS resources.

.PARAMETER DeleteDelayDays
Number of days to wait before automatically deleting terminated resources. Defaults to 7.

.PARAMETER DisableAlerting
Switch to disable alerting automatically after resource termination.

.RETURNS
None. Outputs status messages and warnings to the console.

.NOTES
- Requires the `Invoke-LMApiRequest` function to interact with the LogicMonitor API.
- Requires appropriate API credentials and permissions to modify AWS discovery settings in LogicMonitor.

.EXAMPLES
# Update EC2 discovery settings for a single AWS account in specified regions
Set-LMAWSDiscoverySettings -AccountId 123456789012 -ServiceName "EC2" -Regions "us-east-1","us-west-2"

# Bulk update discovery settings for multiple AWS accounts listed in a CSV file
Set-LMAWSDiscoverySettings -CsvPath "C:\aws_accounts.csv" -ServiceName "EC2" -Regions "us-east-1","us-east-2"

# Enable automatic deletion and disable alerting for EC2 service in a specific account
Set-LMAWSDiscoverySettings -AccountId 123456789012 -ServiceName "EC2" -Regions "us-east-1" -AutoDelete -DeleteDelayDays 10 -DisableAlerting
#>
function Set-LMAWSDiscoverySettings {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$AccountId,

        [Parameter(Mandatory)]
        [string]$ServiceName,  # e.g. "EC2"

        [Parameter(Mandatory)]
        [string[]]$Regions,    # e.g. "us-east-1","us-east-2","us-west-1","us-west-2"

        [Parameter(Mandatory = $false)]
        [string]$CsvPath,

        [switch]$AutoDelete,
        [int]$DeleteDelayDays = 7,
        [switch]$DisableAlerting
    )

    if ($CsvPath) {
        if (-not (Test-Path $CsvPath)) {
            Write-Error "CSV file not found: $CsvPath"
            return
        }

        $csv = Import-Csv $CsvPath
        $accountIds = $csv.AccountId | Sort-Object -Unique
        Write-Host "Updating discovery settings for $($accountIds.Count) AWS accounts..." -ForegroundColor Cyan

        foreach ($id in $accountIds) {
            if ($id -notmatch '^\d+$') {
                Write-Warning "Skipping invalid AccountId value: $id"
                continue
            }

            [int]$parsedId = [int]$id
            Write-Host "Processing AWS Account ID $parsedId..." -ForegroundColor Yellow

            try {
                Set-LMAWSDiscoverySettings -AccountId $parsedId -ServiceName $ServiceName -Regions $Regions -AutoDelete:$AutoDelete -DeleteDelayDays $DeleteDelayDays -DisableAlerting:$DisableAlerting
            } catch {
                Write-Warning "Failed to update account ID $parsedId $_"
            }
        }
        return
    }

    if (-not $AccountId) {
        Write-Error "Either -AccountId or -CsvPath must be specified."
        return
    }

    # Build region map for payload
    $RegionMap = @{}
    foreach ($r in $Regions) { $RegionMap[$r] = 1 }

    $Body = @{
        awsRegionsInfo   = $RegionMap
        isAutoDelete     = [bool]$AutoDelete
        deleteDelayDays  = $DeleteDelayDays
        isAlertDisabled  = [bool]$DisableAlerting
    }

    # Step 1: Retrieve AWS account info using the Get-LMAWSAccountInfo logic
    Write-Host "Retrieving account information for ID $AccountId..." -ForegroundColor Cyan
    $ResourcePath = "/device/groups/$AccountId"
    Write-Debug "GET $ResourcePath"
    $Response = Invoke-LMApiRequest -Method "GET" -ResourcePath $ResourcePath -ErrorAction Stop

    if ($null -eq $Response) {
        Write-Error "Failed to retrieve AWS account group with ID $AccountId."
        return
    }

    if ($null -eq $Response.extra.services) {
        Write-Debug "No 'services' key found under Response.extra."
    } else {
        Write-Debug "Available service keys under extra.services: $($Response.extra.services.PSObject.Properties.Name -join ', ')"
    }

    Write-Debug "Requested ServiceName: $ServiceName"

    # Step 2: Find and validate the service section
    $services = $Response.extra.services | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable
    if (-not $services) {
        Write-Error "No service data found for account $AccountId."
        return
    }

    Write-Debug "Available service keys (case-insensitive): $($services.Keys -join ', ')"

    $normalizedKey = $services.Keys | Where-Object { $_.ToLower() -eq $ServiceName.ToLower() }
    if (-not $normalizedKey) {
        Write-Error "Service '$ServiceName' not found for account $AccountId. Available keys: $($services.Keys -join ', ')"
        return
    }

    $serviceData = $services[$normalizedKey] | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable
    Write-Debug "Service '$ServiceName' matched normalized key '$normalizedKey'."

    Write-Host "Updating discovery settings for $ServiceName in account $AccountId..." -ForegroundColor Yellow

    # Step 3: Handle inheritance and region updates
    if ($serviceData["useDefault"] -eq $true) {
        Write-Host "Service '$ServiceName' currently inherits from Global Settings. Switching to custom settings..." -ForegroundColor Yellow
        $serviceData["useDefault"] = $false
    } else {
        Write-Host "Service '$ServiceName' uses custom settings." -ForegroundColor Green
    }

    # Update monitored regions and discovery flags
    $serviceData["monitoringRegions"] = $Regions
    $serviceData["isAutomaticDeletionEnabled"] = [bool]$AutoDelete
    $serviceData["isAlertingAutomaticallyDisabledAfterTermination"] = [bool]$DisableAlerting
    $serviceData["automaticallyDeleteTerminatedResourcesOffset"] = @{
        units = "DAYS"
        offset = $DeleteDelayDays
    }
    
    # Convert back to a PSCustomObject for PUT compatibility
    Write-Debug "Converting updated service data back to PSCustomObject for PUT..."
    Write-Debug "Service key being updated: $normalizedKey"
    Write-Debug "Modified service data (JSON): $($serviceData | ConvertTo-Json -Depth 5)"

    $Response.extra.services = $services
    $Response.extra.services[$normalizedKey] = $serviceData

    Write-Debug "Updated services object keys: $($Response.extra.services.PSObject.Properties.Name -join ', ')"
    Write-Debug "Service '$normalizedKey' successfully merged into response structure."

    # Step 4: PUT updated service section back
    $putPath = "/device/groups/$AccountId"
    Write-Debug "PUT $putPath"
    Write-Debug "Converting full payload to hashtable before PUT..."
    $BodyForPut = $Response | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable
    Write-Debug "Updated payload preview: $($BodyForPut | ConvertTo-Json -Depth 10)"
    try {
        Invoke-LMApiRequest -Method "PUT" -ResourcePath $putPath -Data $BodyForPut -ErrorAction Stop
    }
    catch {
        $errorMessage = $_.Exception.Message

        if ($errorMessage -match "Permissions are insufficient") {
            Write-Warning "Non-fatal permission warning from LogicMonitor API:"
            Write-Warning $errorMessage
            Write-Warning "Continuing script execution..."
            return
        }
        elseif ($errorMessage -match "Please see https://www.logicmonitor.com/support/lm-cloud") {
            Write-Warning "Non-fatal LogicMonitor API warning encountered. Continuing execution..."
            return
        }
        else {
            Write-Error "Critical error while updating account ID $AccountId. Details: $errorMessage"
        }
    }
}