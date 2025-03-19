function Initialize-SecretVault {
    [CmdletBinding()]
    param (
        [string]$VaultName = "Logic.Monitor"
    )

    Try {
        Get-SecretVault -Name $VaultName -ErrorAction Stop | Out-Null
        Write-Host "Using existing vault: $VaultName" -ForegroundColor Yellow
    }
    Catch {
        If ($_.Exception.Message -like "*Vault $VaultName does not exist in registry*") {
            Write-Host "Creating new credential vault: $VaultName" -ForegroundColor Yellow
            Register-SecretVault -Name $VaultName -ModuleName Microsoft.PowerShell.SecretStore
            Get-SecretStoreConfiguration | Out-Null
        }
        else {
            throw $_
        }
    }
}