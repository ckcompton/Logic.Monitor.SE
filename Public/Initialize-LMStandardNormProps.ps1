<#
.SYNOPSIS
    Initializes standard normalized properties in LogicMonitor.

.DESCRIPTION
    This script:
    1. Verifies that you are connected to LogicMonitor (via Connect-LMAccount).
    2. Iterates through a list of standard property aliases (e.g., "location.region", "owner", etc.).
    3. For each alias, it calls New-LMNormalizedProperties if the alias is missing,
       or Set-LMNormalizedProperties if it is partially missing some properties.

.EXAMPLE
    PS> Initialize-LMStandardNormProps

    This will attempt to create/update the standardized normalized properties in LogicMonitor.
#>

Function Initialize-LMStandardNormProps {

    [CmdletBinding()]
    Param()

    Begin {}
    Process {
        # 1. Check if we are logged in with valid LogicMonitor API credentials
        If (-not (Get-LMAccountStatus).Valid) {
            Write-Error "Not logged into LogicMonitor. Use Connect-LMAccount to log in and try again."
            Return
        }

        # 2. Define a static list of standard normalized properties
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

        # 3. Retrieve current normalized properties from LogicMonitor
        $ExistingProps = Get-LMNormalizedProperties

        # 4. Process each standard alias
        foreach ($item in $NormalizedProperties) {
            Write-Host "Checking alias: '$($item.Alias)'..."

            # 4a. Get existing rows (if any) for this alias
            $aliasRows = $ExistingProps | Where-Object { $_.alias -eq $item.Alias }

            if (-not $aliasRows) {
                # 4b. Alias does not exist -> Create it with all standard properties
                Write-Host " -> Alias '$($item.Alias)' does not exist. Creating..."
                New-LMNormalizedProperties -Alias $item.Alias -Properties $item.Properties
            }
            else {
                Write-Host " -> Alias '$($item.Alias)' found. Checking for missing properties..."

                # 4c. Determine which standard properties are missing
                $aliasHostProps = $aliasRows.hostProperty
                $missingProps   = $item.Properties | Where-Object { $aliasHostProps -notcontains $_ }

                if ($missingProps) {
                    Write-Host "    Missing properties: $($missingProps -join ', ')"
                    # 4d. Add each missing property individually
                    foreach ($prop in $missingProps) {
                        Set-LMNormalizedProperties -Add -Alias $item.Alias -Properties @($prop)
                    }
                }
                else {
                    Write-Host "    No missing properties. Nothing to do."
                }
            }

            Write-Host  # Blank line for readability
        }

        Write-Host "All standard normalized properties have been processed."
    }
    End {}
}