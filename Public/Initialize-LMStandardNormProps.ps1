<#
.SYNOPSIS
    Initializes standard normalized properties in LogicMonitor.

.DESCRIPTION
    This script defines a set of "standard" properties (like location.region, environment, etc.), 
    then loops through each property to call "New-LMNormalizedProperties" with its alias 
    and array of possible property names.

.EXAMPLE
    .\Initialize-LMStandardNormProps.ps1
    Initializes all standard normalized properties.

.NOTES
    - Assumes you are already connected to LogicMonitor (e.g., via Connect-LMAccount).
    - Requires a function named "New-LMNormalizedProperties" in scope.
#>

[CmdletBinding()]
Param()

# 1. Define the list of standard normalized properties as an array of PSCustomObjects.
$NormalizedProperties = @(
    [PSCustomObject]@{
        Alias      = 'location.region'
        Properties = @('sn.location.region','location.region','auto.location.region')
    },
    [PSCustomObject]@{
        Alias      = 'location.country'
        Properties = @('sn.location.country','location.country','auto.location.country')
    },
    [PSCustomObject]@{
        Alias      = 'location.state'
        Properties = @('sn.location.state','location.state','auto.location.state')
    },
    [PSCustomObject]@{
        Alias      = 'location.city'
        Properties = @('sn.location.city','location.city','auto.location.city')
    },
    [PSCustomObject]@{
        Alias      = 'location.site'
        Properties = @('sn.location.street','location.site','auto.location.site')
    },
    [PSCustomObject]@{
        Alias      = 'location.type'
        Properties = @('sn.location.type','location.type','auto.location.type')
    },
    [PSCustomObject]@{
        Alias      = 'environment'
        Properties = @('sn.environment','environment','system.aws.tag.environment','system.azure.tag.environment','system.gcp.tag.environment')
    },
    [PSCustomObject]@{
        Alias      = 'owner'
        Properties = @('sn.owner','owner','system.aws.tag.owner','system.azure.tag.owner','system.gcp.tag.owner')
    },
    [PSCustomObject]@{
        Alias      = 'version'
        Properties = @('version','system.aws.tag.version','system.azure.tag.version','system.gcp.tag.version')
    },
    [PSCustomObject]@{
        Alias      = 'service'
        Properties = @('sn.service.name','service','system.aws.tag.service','system.azure.tag.service','system.gcp.tag.service')
    },
    [PSCustomObject]@{
        Alias      = 'service_component'
        Properties = @('sn.service_component','service_component','system.aws.tag.service_component','system.azure.tag.service_component','system.gcp.tag.service_component')
    },
    [PSCustomObject]@{
        Alias      = 'application'
        Properties = @('sn.application','application','system.aws.tag.application','system.azure.tag.application','system.gcp.tag.application')
    },
    [PSCustomObject]@{
        Alias      = 'customer'
        Properties = @('sn.customer','customer','system.aws.tag.customer','system.azure.tag.customer','system.gcp.tag.customer')
    }
)

# 2. Loop through each entry and call New-LMNormalizedProperties
foreach ($item in $NormalizedProperties) {
    Write-Host "Setting Normalized Property Alias: $($item.Alias)"
    New-LMNormalizedProperties -Alias $item.Alias -Properties $item.Properties
}

Write-Host "All standard normalized properties have been initialized."
