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