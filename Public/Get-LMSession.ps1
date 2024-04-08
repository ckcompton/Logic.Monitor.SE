<#
.SYNOPSIS
    This function retrieves a session from Logic Monitor.

.DESCRIPTION
    The Get-LMSession function uses the account name provided to retrieve a session from Logic Monitor. 
    It uses a secret API key stored in a vault to authenticate the request.

.PARAMETER AccountName
    The name of the account for which the session details are to be retrieved. This is a mandatory parameter.

.EXAMPLE
    Get-LMSession -AccountName "Account1"

    This command retrieves the session details for the account named "Account1".

.INPUTS
    System.String. You can pipe a string that contains the account name to Get-LMSession.

.OUTPUTS
    The function returns the response from the Invoke-RestMethod cmdlet, which contains the session details.

.NOTES
    The function throws an error if it fails to retrieve the session details.
#>
Function Get-LMSession {
    Param (
        [Parameter(Mandatory)]
        [String]$AccountName
    )

    $VaultName = "Logic.Monitor"
    $VaultKeyPrefix = "LMSessionSync"

    Try{
        $ApiKey = Get-Secret -Name $VaultKeyPrefix-RESTAPIKey -Vault  $VaultName -AsPlainText -ErrorAction Stop
        $Response = Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8072/api/v1/portal/$AccountName" -Headers @{"X-API-Key"=$ApiKey}

        Return $Response
    }
    Catch {
        throw "Error retrieving session details: $_"
    }
}