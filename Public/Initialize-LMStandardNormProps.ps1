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
                    Properties = @('location.region','auto.location.region')
                },
                [PSCustomObject]@{
                    Alias      = 'location.country'
                    Properties = @('location.country','auto.location.country')
                },
                [PSCustomObject]@{
                    Alias      = 'location.state'
                    Properties = @('location.state','auto.location.state')
                },
                [PSCustomObject]@{
                    Alias      = 'location.city'
                    Properties = @('location.city','auto.location.city')
                },
                [PSCustomObject]@{
                    Alias      = 'location.site'
                    Properties = @('location.site','auto.location.site')
                },
                [PSCustomObject]@{
                    Alias      = 'location.type'
                    Properties = @('location.type','auto.location.type')
                },
                [PSCustomObject]@{
                    Alias      = 'environment'
                    Properties = @('environment','system.aws.tag.environment','system.azure.tag.environment','system.gcp.tag.environment')
                },
                [PSCustomObject]@{
                    Alias      = 'owner'
                    Properties = @('owner','system.aws.tag.owner','system.azure.tag.owner','system.gcp.tag.owner')
                },
                [PSCustomObject]@{
                    Alias      = 'version'
                    Properties = @('version','system.aws.tag.version','system.azure.tag.version','system.gcp.tag.version')
                },
                [PSCustomObject]@{
                    Alias      = 'service'
                    Properties = @('service','system.aws.tag.service','system.azure.tag.service','system.gcp.tag.service')
                },
                [PSCustomObject]@{
                    Alias      = 'service_component'
                    Properties = @('service_component','system.aws.tag.service_component','system.azure.tag.service_component','system.gcp.tag.service_component')
                },
                [PSCustomObject]@{
                    Alias      = 'application'
                    Properties = @('application','system.aws.tag.application','system.azure.tag.application','system.gcp.tag.application')
                }
            )
            # Retrieve existing props so we don't overwrite customers existing values. 
            $ExistingProps = Get-LMNormalizedProperties
            foreach ($item in $NormalizedProperties) {
                Write-Host "Checking alias: $($item.Alias)"

                # Get the existing rows for this alias (if any)
                $aliasRows = $ExistingProps | Where-Object { $_.alias -eq $item.Alias }
                if (-not $aliasRows) {
                    # Alias doesn't exist at all, so create it with all standard properties
                    Write-Host " -> Alias '$($item.Alias)' does not exist. Creating it with all standard properties..."
                    New-LMNormalizedProperties -Alias $item.Alias -Properties $item.Properties
                }
                else {
                    Write-Host " -> Alias '$($item.Alias)' found. Checking for any missing properties..."
            
                    # Gather which standard properties are missing
                    $aliasHostProps = $aliasRows.hostProperty
                    $missingProps   = $item.Properties | Where-Object { $aliasHostProps -notcontains $_ }

                    if ($missingProps) {
                        Write-Host "    Missing properties: $($missingProps -join ', ')"
                        foreach($prop in $missingProps){
                            Set-LMNormalizedProperties -Add -Alias $item.Alias -Properties @($prop)
                        }
                    }
                    else {
                        Write-Host "No missing properties. Nothing to do."
                    }
                }
            }
        
            Write-Host "`nAll standard normalized properties have been processed."

        }Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}

