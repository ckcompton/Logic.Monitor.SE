<#
.SYNOPSIS
    This function sets the data model for a Logic Monitor device.

.DESCRIPTION
    The Set-LMDataModel function takes a model object and optional parameters for properties, hostname, display name, and simulation type. 
    It modifies the model object based on the provided parameters and sets the data model for the device.

.PARAMETER ModelObject
    The model object to be modified. This is a mandatory parameter. The object must be a valid JSON object and must contain the properties "Datasources", "Properties", "DisplayName", "HostName", and "SimulationType".

.PARAMETER Properties
    A hashtable of properties to be added to the model object.

.PARAMETER Hostname
    The hostname to be set in the model object.

.PARAMETER DisplayName
    The display name to be set in the model object.

.PARAMETER SimulationType
    The simulation type to be set in the model object. Can be "8to5", "random", "replication", or "replay_model".

.EXAMPLE
    Set-LMDataModel -ModelObject $Model -Hostname "NewHostname" -DisplayName "NewDisplayName" -SimulationType "random"

    This command modifies the model object represented by the $Model variable, setting the hostname to "NewHostname", the display name to "NewDisplayName", and the simulation type to "random".

.INPUTS
    System.Object. You can pipe a model object to Set-LMDataModel.

.OUTPUTS
    The function reutrns an updated model object

.NOTES
    The function throws an error if the model object is not a valid JSON object or if it does not contain the required properties.
#>
Function Set-LMDataModel {
    Param(
        [Parameter(Mandatory)]
        [ValidateScript({ 
            If(Test-Json $_ -ErrorAction SilentlyContinue){$TestObject = $_ | ConvertFrom-Json -Depth 10}
            Else{ $TestObject = $_}

            $RequiredProperties= @("Datasources","Properties","DisplayName","HostName","SimulationType")
            $Members= Get-Member -InputObject $TestObject -MemberType NoteProperty
            If($Members){
                $MissingProperties= Compare-Object -ReferenceObject $Members.Name -DifferenceObject $RequiredProperties -PassThru | Where-Object {$_.SideIndicator -eq "=>"}
            }
            #Missing expected schema properties, dont continue
            If (!$MissingProperties){$True}
            Else{Throw [System.Management.Automation.ValidationMetadataException] "Missing schema properties: $($missingProperties -Join ",")"}
        })]
        $ModelObject,

        [Hashtable]$Properties,

        [String]$Hostname,

        [String]$DisplayName,

        [ValidateSet("8to5","random","replication","replay_model")]
        [String]$SimulationType
    )
    Begin{
        $WorkingDataModelObject = $ModelObject | ConvertTo-Json -depth 10 | ConvertFrom-Json
    }
    Process{
        If($Hostname){$WorkingDataModelObject.Hostname = $Hostname}

        If($DisplayName){$WorkingDataModelObject.DisplayName = $DisplayName}

        If($SimulationType){$WorkingDataModelObject.SimulationType = $SimulationType}

        If($Properties){
            Foreach ($Enum in $Properties.GetEnumerator()){
                $WorkingDataModelObject.Properties | Add-Member -MemberType NoteProperty -Name $("autodiscovery." + $Enum.Name.ToString().replace("auto.","")) -Value $($Enum.Value.ToString().trim()) -Force
            }
        }
    }
    End{
        Return $WorkingDataModelObject
    }
}