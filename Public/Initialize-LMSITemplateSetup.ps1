<#
.SYNOPSIS
    This function initializes a LogicMonitor ServiceInsight that contains default standardized properties that all clients should utilize in SI Templates. 
    It also pushes the PropertySource that will make those properties Auto.props. 

.DESCRIPTION
    The Initialize LMSITemplate Setup script generates an SI that contains normalized properties, then pushes a PropertySource to turn those into Auto.props. 

.PARAMETER SetupDummyServiceInsight
    A switch to control the setup of the LM SI. This parameter is used in the 'Individual' parameter set.

.EXAMPLE
    Initialize-LMSITemplateSetup -SetupDummyServiceInsight

    This command runs all setup processes for the SI and PropSource

.INPUTS
    The function does not accept input from the pipeline.

.OUTPUTS
    The function does not return any output.

.NOTES
    The function throws an error if it fails to set up any component.
#>

Function Initialize-LMSITemplateSetup {
    
    [CmdletBinding()]
    Param ()

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($(Get-LMAccountStatus).Valid) {
            # Base URI for module templates
            $GitubURI = "https://raw.githubusercontent.com/Sims737477"

            $ServiceInsightProps = @{
                device = @(
                    @{
                        deviceGroupFullPath = "Devices By Type/Collectors";
                        deviceDisplayName   = "*";
                        deviceProperties    = @()
                    }
                )
            } | ConvertTo-Json -Depth 3
                
            #Create pre-built hashtable of SI properties
            $SIProperties = @{
                "predef.bizService.evalMembersInterval" = "30"
                "location.region"                       = "fill_me_in"
                "location.country"                      = "fill_me_in"
                "location.state"                        = "fill_me_in"
                "location.city"                         = "fill_me_in"
                "location.site"                         = "fill_me_in"
                "location.type"                         = "fill_me_in"
                "environment"                           = "fill_me_in"
                "owner"                                 = "fill_me_in"
                "version"                               = "fill_me_in"
                "service"                               = "fill_me_in"
                "service_component"                     = "fill_me_in"
                "application"                           = "fill_me_in"
                "customer"                              = "fill_me_in"
                "sn.location.region"                    = "fill_me_in"
                "sn.location.country"                   = "fill_me_in"
                "sn.location.state"                     = "fill_me_in"
                "sn.location.city"                      = "fill_me_in"
                "sn.location.street"                    = "fill_me_in"
                "sn.location.type"                      = "fill_me_in"
                "sn.environment"                        = "fill_me_in"
                "sn.service.name"                       = "fill_me_in"
                "sn.service_component"                  = "fill_me_in"
                "sn.application"                        = "fill_me_in"
                "sn.customer"                           = "fill_me_in"
                "DummyService"                          = "True"
                "predef.bizservice.members"             = "$ServiceInsightProps"
            }

            #Before provisioning the SI we need an active collector for the PropSource to work. 
            $Collector = Get-LMCollector -BatchSize 1
                
            If ($Collector) {
                #Create new SI resource
                $ServiceInsightResource = Get-LMDevice -name "SI_Prop_Normalizer"
                If (!$ServiceInsightResource) {
                    Write-Information "[INFO]: Service insight resource (LogicMonitor SI Property Normalizer) is deploying"
                    $ServiceInsightResource = New-LMDevice -name "SI_Prop_Normalizer" -DisplayName "LogicMonitor SI Property Normalizer" -PreferredCollectorId $Collector[0].id -DeviceType 6 -Properties $SIProperties
                }
                Else {
                    Write-Information "[INFO]: Service insight resource (LogicMonitor SI Property Normalizer) already exists, skipping creation"
                }
            }
            Else {
                Write-Error "[ERROR]: There are no collectors in the portal. Please assign a collector to the Service once they're available." 
                # IF we don't have a collector we can still provision the SI, but the propsource won't run and the collector needs to be manually assigned. 
                #Create new SI resource
                $ServiceInsightResource = Get-LMDevice -name "SI_Prop_Normalizer"
                If (!$ServiceInsightResource) {
                    Write-Information "[INFO]: Service insight resource (LogicMonitor SI Property Normalizer) is deploying"
                    $ServiceInsightResource = New-LMDevice -name "SI_Prop_Normalizer" -DisplayName "LogicMonitor SI Property Normalizer" -PreferredCollectorId -4 -DeviceType 6 -Properties $SIProperties
                    Write-Error "The SI Prop Normalizer was deployed, but there were no active Collectors to assign to the SI. Please manually assign the collector."
                }
                Else {
                    Write-Information "[INFO]: Service insight resource (LogicMonitor SI Property Normalizer) already exists, skipping creation"
                }
            }

            # Check and deploy the PropertySource used to add auto.props for normalization. 
            $NormalizingPropSource = Get-LMPropertySource -Name "NormalisedProps"
            If (!$NormalizingPropSource) {
                #Upload PropertyNormalizer PropertySource. 
                Try {
                    $NormalizingPropSource = (Invoke-WebRequest -Uri "$GitubURI/LM_templates/main/NormalisedProps.json" -UseBasicParsing).Content
                    Import-LMLogicModule -File $NormalizingPropSource -Type propertyrules -ErrorAction Stop
                }
                Catch {
                    #Error
                    Write-Error "[ERROR]: Unable to add PropertySource template from source: $_" 
                }

            }
            Else {
                Write-Information "[INFO]: Property Normalizing PropSource Already Exists."
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}

