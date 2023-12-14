<#
.SYNOPSIS
Invokes Submit-LMDataModel for an array of models

.DESCRIPTION
Based on the specified ModelPath, all discovered models are submitted to Submit-LMDataModel. ModelPath should contain a subfolder called Models which contains the generated model JSON files and additionally a Scipts folder with an pre processing scripts you want executed priot to model submission.

.PARAMETER BearerToken
Logic Monitor bearer token for connecting to the targeted portal

.PARAMETER AccountName
LogicMontior Portal to submit models to

.PARAMETER ModelPath
File path where models are located

.PARAMETER LogSourceName
Submitted Logs will have a log source name appended as metadata, defaults to PMv1 if not set

.PARAMETER LogFileName
File name to use for transcript files, defaults to Runner.txt if not set

.PARAMETER LogResult
Switch to enable logging of submission results to LogicMonitor. If not set no logs will be generated.

.PARAMETER LogResourceId
Hashtable containing the required mapping info for lm logs.

.PARAMETER ConcurrencyLimit
Number of models to process in parallel, defaults to 5. Running too many concurrently can result in 429 errors.

.PARAMETER RunPreFlightScripts
Switch to enable the procesing of scripts included in the module directory under the script folder.

.EXAMPLE
Invoke-LMDataModelRunner -BearerToken XXXXXXX -AccountName portal_name -ModelPath C:\LogicMonitor\<ModelDir> -LogSourceName "DL-PMv1" -LogFileName Runner.txt -LogResult -LogResourceId @{"system.deviceId"="123"}

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function Invoke-LMDataModelRunner {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$BearerToken,

        [Parameter(Mandatory)]
        [String]$AccountName,

        [Parameter(Mandatory)]
        [String]$ModelPath,
        
        [Parameter(ParameterSetName = 'LogResult')]
        [String]$LogSourceName = "PMv1",

        [String]$DatasourceSuffix = "_PMv1",

        [Parameter(ParameterSetName = 'LogResult')]
        [String]$LogFileName = "RunnerLog.txt",

        [Parameter(ParameterSetName = 'LogResult')]
        [Switch]$LogResult,

        [Parameter(ParameterSetName = 'LogResult')]
        [Hashtable]$LogResourceId,

        [Parameter(ParameterSetName = 'LogResult')]
        [Hashtable]$LogAdditionalMetadata,

        [Int]$ConcurrencyLimit = 5,

        [Switch]$MultiThreadDatasourceSubmission,

        [Switch]$RunPreFlightScripts
    )

    
    #Load models
    $Models = (Get-ChildItem "$ModelPath\Models" -Filter *.json).FullName | ForEach-Object {Get-Content $_ -Raw | ConvertFrom-Json -Depth 10}

    #Load any model specific scripts/funcitons
    If($RunPreFlightScripts){
        $AdditionalScripts = @( Get-ChildItem -Path $ModelPath\Scripts\*.ps1 -ErrorAction SilentlyContinue -Recurse)
    
        #Dot source the files
        Foreach ($import in @($AdditionalScripts)) {
            Try {
                #Run preflight scripts pass our models and connection details for usage
                . $import.fullname -Models $Models -BearerToken $BearerToken -AccountName $AccountName
            }
            Catch {
                Write-Error -Message "Failed to import function $($import.fullname): $_"
            }
        }
    }

    $TotalResults = Measure-Command {
        #Run models
        $Models | ForEach-Object -Parallel {
            #Manually load modules since running as a job they are not automatically loaded
            Import-Module Microsoft.PowerShell.SecretStore -ErrorAction SilentlyContinue
            Import-Module Microsoft.PowerShell.SecretManagement -ErrorAction SilentlyContinue
            Import-Module Logic.Monitor -ErrorAction SilentlyContinue
            Import-Module Logic.Monitor.SE -ErrorAction SilentlyContinue

            #Dev module import for testing, not needed for production
            Import-Module /Users/stevenvillardi/Documents/GitHub/Logic.Monitor/Dev.Logic.Monitor.psd1 -Force -ErrorAction SilentlyContinue
            Import-Module /Users/stevenvillardi/Documents/GitHub/Logic.Monitor.SE/Dev.Logic.Monitor.SE.psd1 -Force -ErrorAction SilentlyContinue

            #Start last run log
            $RunnerTranscriptPath = "$using:ModelPath\$($_.DisplayName)-$using:LogFileName"
            If($using:LogResult){Start-Transcript -Path $RunnerTranscriptPath -UseMinimalHeader -ErrorAction SilentlyContinue}
            
            If($MultiThreadDatasourceSubmission){
                #Call Submit-LMDataModelConcurrent to run DS processing in parallel
                $ModelResult = Measure-Command {Submit-LMDataModelConcurrent -ModelObject $_ -BearerToken $using:BearerToken -AccountName $using:AccountName -DatasourceSuffix $using:DatasourceSuffix -ConcurrencyLimit $using:ConcurrencyLimit}
            }
            Else{
                #Connect to portal
                Connect-LMAccount -BearerToken $using:BearerToken -AccountName $using:AccountName

                $ModelResult = Measure-Command {Submit-LMDataModel -ModelObject $_ -DatasourceSuffix $using:DatasourceSuffix}
            }
            $ModelTime = [Math]::Round(($ModelResult).TotalMinutes,2)

            #End last run log
            If($using:LogResult){Stop-Transcript -ErrorAction SilentlyContinue}

            $LastRunLog = Get-Content $RunnerTranscriptPath -Raw -ErrorAction SilentlyContinue

            #Send Log Message with Result
            If($using:LogResult){
                $DSList = $_.Datasources.DatasourceName -join ","
                Send-LMLogMessage -Message $LastRunLog -resourceMapping $using:LogResourceId -Metadata $($LogAdditionalMetadata + @{"modelSimulationType"=$_.SimulationType;"modelDatasourceList"=$DSList;"modelRuntimeInMin"=$ModelTime;"modelLogSource"=$using:LogSourceName;"modelDeviceDisplayName"=$_.DisplayName})
            }

            #Disconnect from portal
            Disconnect-LMAccount
        } -ThrottleLimit $ConcurrencyLimit
    }
    return $TotalResults.TotalMinutes
}