# Helper Functions for Session Synchronization
$script:Config = @{
    VaultName      = "Logic.Monitor"
    VaultKeyPrefix = "LMSessionSync"
    ServerConfig   = @{
        Address  = '127.0.0.1'
        Port     = 8072
        Protocol = 'Http'
    }
    Security       = @{
        Origin   = '*'
        Methods  = '*'
        Headers  = '*'
        Duration = 7200
    }
}

function Initialize-SecretVault {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$VaultName
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

function Initialize-VaultAccess {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$VaultName
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

function Initialize-ApiKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$VaultName,
        [Parameter(Mandatory)]
        [string]$VaultKeyPrefix
    )

    $apiKey = (1..64 | ForEach-Object { [byte](Get-Random -Max 256) } | ForEach-Object ToString X2) -join ''
    Set-Secret -Name "$VaultKeyPrefix-RESTAPIKey" -Vault $VaultName -Secret $apiKey -Metadata @{
        Modified = (Get-Date).ToString('o')
        Portal   = "SessionSync-ApiKey"
    }
    return $apiKey
}

function Get-SessionData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$AccountName,
        [Parameter(Mandatory)]
        [string]$VaultName,
        [Parameter(Mandatory)]
        [string]$VaultKeyPrefix
    )

    Try {
        $secretData = Get-Secret -Name "$VaultKeyPrefix-$AccountName" -Vault $VaultName -AsPlainText -ErrorAction Stop
        return $secretData
    }
    Catch {
        throw "Failed to retrieve session data: $_"
    }
}

# Export functions for module use
Export-ModuleMember -Function @(
    'Initialize-SecretVault',
    'Initialize-VaultAccess',
    'Initialize-ApiKey',
    'Get-SessionData'
) -Variable @('Config') 