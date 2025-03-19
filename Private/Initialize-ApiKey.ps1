function Initialize-ApiKey {
    [CmdletBinding()]
    param (
        [string]$VaultName = "Logic.Monitor",
        [string]$VaultKeyPrefix = "LMSessionSync"
    )

    $apiKey = (1..64 | ForEach-Object { [byte](Get-Random -Max 256) } | ForEach-Object ToString X2) -join ''
    Set-Secret -Name "$VaultKeyPrefix-RESTAPIKey" -Vault $VaultName -Secret $apiKey -Metadata @{
        Modified = (Get-Date).ToString('o')
        Portal   = "SessionSync-ApiKey"
    }
    return $apiKey
}