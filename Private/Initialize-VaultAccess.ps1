function Initialize-VaultAccess {
    [CmdletBinding()]
    param (
        [string]$VaultName = "Logic.Monitor"
    )

    Try {
        $vaultCred = Read-Host "Enter vault credentials" -AsSecureString
        Unlock-SecretVault -Name $VaultName -Password $vaultCred -ErrorAction Stop
        Set-PodeState -Name 'VaultUnlock' -Value $vaultCred | Out-Null
        return $true
    }
    Catch {
        Write-Error "Failed to unlock vault: $_"
        return $false
    }
}