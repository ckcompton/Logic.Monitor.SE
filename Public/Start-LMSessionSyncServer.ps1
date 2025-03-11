<#
.SYNOPSIS
    Starts a session synchronization server for Logic Monitor.
.DESCRIPTION
    The Start-LMSessionSyncServer function starts a Pode server that synchronizes sessions for Logic Monitor.
    It manages a secret vault for session storage and provides logging options.
.PARAMETER EnableRequestLogging
    Enables request logging when specified.
.PARAMETER EnableErrorLogging
    Enables error logging when specified.
.EXAMPLE
    Start-LMSessionSyncServer -EnableRequestLogging -EnableErrorLogging
#>
Function Start-LMSessionSyncServer {
    [CmdletBinding()]
    Param(
        [Switch]$EnableRequestLogging,
        [Switch]$EnableErrorLogging
    )
    
    Begin {
        Initialize-SecretVault -VaultName $Config.VaultName
    }
    
    Process {
        Start-PodeServer {
            # Initialize vault and server state
            if (-not (Initialize-VaultAccess -VaultName $Config.VaultName)) {
                return
            }

            $apiKey = Initialize-ApiKey -VaultName $Config.VaultName -VaultKeyPrefix $Config.VaultKeyPrefix

            # Set server state
            @('VaultName', 'VaultKeyPrefix', 'VaultApiKey') | ForEach-Object {
                Set-PodeState -Name $_ -Value $(
                    switch ($_) {
                        'VaultName' { $Config.VaultName }
                        'VaultKeyPrefix' { $Config.VaultKeyPrefix }
                        'VaultApiKey' { $apiKey }
                    }
                ) | Out-Null
            }

            # Configure server
            Add-PodeEndpoint -Address $Config.ServerConfig.Address -Port $Config.ServerConfig.Port -Protocol $Config.ServerConfig.Protocol
            Set-PodeSecurityAccessControl -Origin $Config.Security.Origin -Methods $Config.Security.Methods -Headers $Config.Security.Headers -Duration $Config.Security.Duration

            # Configure logging
            if ($EnableRequestLogging) { New-PodeLoggingMethod -Terminal | Enable-PodeRequestLogging }
            if ($EnableErrorLogging) { New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging }

            # Authentication
            New-PodeAuthScheme -ApiKey | Add-PodeAuth -Name 'Auth' -Sessionless -ScriptBlock {
                param($key)
                
                $apiKey = Get-PodeState -Name 'VaultApiKey'

                if ($key.toString() -eq $apiKey.toString()) {
                    return @{ User = @{ ID = '1' } }
                }
                elseif ($WebEvent.Request.Headers.Origin -match '^https://deploy\.lmdemo\.us|^http://localhost:') {
                    return @{ User = @{ ID = '2' } }
                }
                
                return $null
            }

            # Routes
            Add-PodeRoute -Method Get -Path '/api/v1/portal/:AccountName' -Authentication 'Auth' -ScriptBlock {
                Try {
                    $vaultName = Get-PodeState -Name 'VaultName'
                    $vaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                    $accountName = $WebEvent.Parameters['AccountName']
                    
                    Unlock-SecretVault -Name $vaultName -Password (Get-PodeState -Name 'VaultUnlock')
                    $secretData = Get-SessionData -AccountName $accountName -VaultName $vaultName -VaultKeyPrefix $vaultKeyPrefix
                    Write-PodeJsonResponse -Value $secretData
                }
                Catch {
                    Write-PodeTextResponse -Value $_.Exception.Message -StatusCode 500
                }
            }

            # Health check routes
            @('/api/v1/portal', '/api/v1/health') | ForEach-Object {
                Add-PodeRoute -Method Options -Path $_ -ScriptBlock {
                    Write-PodeTextResponse -Value 'OK' -StatusCode 200
                }
            }
            
            Add-PodeRoute -Method Get -Path '/api/v1/health' -ScriptBlock {
                Write-PodeTextResponse -Value 'OK' -StatusCode 200
            }

            Add-PodeRoute -Method Get -Path '/api/v1/portal' -Authentication 'Auth' -ScriptBlock {
                Try {
                    $vaultName = Get-PodeState -Name 'VaultName'
                    $vaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                    
                    Unlock-SecretVault -Name $vaultName -Password (Get-PodeState -Name 'VaultUnlock')
                    $sessions = Get-SecretInfo -Vault $vaultName | 
                        Where-Object { $_.Name -like "$vaultKeyPrefix*" -and $_.Name -notlike "*RESTAPIKey" }
                    
                    $secretData = $sessions | ForEach-Object {
                        Try {
                            $secret = Get-Secret -Vault $vaultName -Name $_.Name -AsPlainText -ErrorAction Stop
                            [PSCustomObject]@{
                                Portal   = $_.Metadata["Portal"]
                                Modified = $_.Metadata["Modified"]
                                Type     = $_.Metadata["Type"]
                                Secret   = $secret | ConvertFrom-Json
                            }
                        }
                        Catch {
                            Write-Error "Failed to process session: $($_.Metadata['Portal']): $_"
                            $null
                        }
                    } | Where-Object { $_ -ne $null }
                    
                    Write-PodeJsonResponse -Value $secretData
                }
                Catch {
                    Write-PodeTextResponse -Value $_.Exception.Message -StatusCode 500
                }
            }

            Add-PodeRoute -Method Post -Path '/api/v1/portal/:AccountName' -ScriptBlock {
                Try {
                    $vaultName = Get-PodeState -Name 'VaultName'
                    $vaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                    $accountName = $WebEvent.Parameters['AccountName']
                    $secretData = $WebEvent.Data | ConvertTo-Json
                    
                    Unlock-SecretVault -Name $vaultName -Password (Get-PodeState -Name 'VaultUnlock')
                    Set-Secret -Name "$vaultKeyPrefix-$accountName" -Vault $vaultName -Secret $secretData -Metadata @{
                        Modified = (Get-Date).ToString('o')
                        Type     = "SessionSync"
                        Portal   = $accountName
                    }
                    
                    Write-PodeJsonResponse -Value $secretData
                }
                Catch {
                    Write-PodeTextResponse -Value $_.Exception.Message -StatusCode 500
                }
            }

            Register-PodeEvent -Type Terminate -Name 'CleanupSessions' -ScriptBlock {
                Try {
                    $vaultName = Get-PodeState -Name 'VaultName'
                    $vaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                    
                    Unlock-SecretVault -Name $vaultName -Password (Get-PodeState -Name 'VaultUnlock')
                    $sessions = Get-SecretInfo -Vault $vaultName | 
                        Where-Object { $_.Name -like "*$vaultKeyPrefix*" }
                    
                    foreach ($session in $sessions) {
                        Try {
                            Remove-Secret -Vault $vaultName -Name $session.Name -ErrorAction Stop
                            Write-Host "Cleared session: $($session.Metadata['Portal'])" -ForegroundColor Green
                        }
                        Catch {
                            Write-Error "Failed to clear session: $($session.Metadata['Portal']): $_"
                        }
                    }
                }
                Finally {
                    Disconnect-LMAccount
                }
            }
        }
    }
    
    End {}
}