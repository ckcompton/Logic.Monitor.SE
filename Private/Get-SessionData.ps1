function Get-SessionData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$AccountName,
        [string]$VaultName = "Logic.Monitor",
        [string]$VaultKeyPrefix = "LMSessionSync"
    )

    Try {
        $secretData = Get-Secret -Name "$VaultKeyPrefix-$AccountName" -Vault $VaultName -AsPlainText -ErrorAction Stop
        return $secretData
    }
    Catch {
        throw "Failed to retrieve session data: $_"
    }
}