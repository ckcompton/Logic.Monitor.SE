<#
.SYNOPSIS
    Initializes standard normalized properties in LogicMonitor.

.DESCRIPTION
    This script:
    Checks that you are connected to LogicMonitor (via Connect-LMAccount).
    Iterates a list of standard property aliases (e.g. "location.region", "owner", etc.)
    and calls New-LMNormalizedProperties for each alias and its possible sources.

.EXAMPLE
    Initialize-LMStandardNormProps.ps1
    This will attempt to create/update the normalized properties in LogicMonitor.
#>
Function Initialize-LMStandardNormProps {

    [CmdletBinding()]
    Param()

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($(Get-LMAccountStatus).Valid) {
            # Define your list of standard normalized properties as an array of PSCustomObjects
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
            
            foreach ($item in $NormalizedProperties) {
                Write-Host "Configuring normalized property Alias: $($item.Alias)"
                try {
                    New-LMNormalizedProperties -Alias $item.Alias -Properties $item.Properties
                    Write-Host "  --> Success: Alias '$($item.Alias)'"
                }
                catch {
                    Write-Error "  --> Failed to set Alias '$($item.Alias)': $($_.Exception.Message)"
                }
            }
        
            Write-Host "`nAll standard normalized properties have been processed."

        }Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}

