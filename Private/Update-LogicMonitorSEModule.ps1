# Auto-Update PowerShell
Function Update-LogicMonitorSEModule {
    [CmdletBinding()]
    Param (
        [String]$Module = 'Logic.Monitor.SE',
        [Boolean]$UninstallFirst = $False,
        [Switch]$CheckOnly
    )

    try {
        # Read the currently installed version
        $Installed = Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue

        if (-not $Installed) {
            Write-Verbose "Module $Module is not installed; skipping update check."
            return
        }

        # There might be multiple versions
        if ($Installed -is [Array]) {
            $InstalledVersion = $Installed[0].Version
        }
        elseif ($Installed.Version) {
            $InstalledVersion = $Installed.Version
        }
        else {
            Write-Verbose "Unable to determine installed version for module $Module; skipping update check."
            return
        }

        # Lookup the latest version online
        try {
            $Online = Find-Module -Name $Module -ErrorAction Stop
            $OnlineVersion = $Online.Version
        }
        catch {
            Write-Verbose "Unable to query online version for module $Module. $_"
            return
        }

        # Compare the versions
        if ([System.Version]$OnlineVersion -le [System.Version]$InstalledVersion) {
            Write-Information "[INFO]: Module $Module version $InstalledVersion is the latest version."
            return
        }

        Write-Information "[INFO]: You are currently using an outdated version ($InstalledVersion) of $Module."

        if ($CheckOnly) {
            Write-Information "[INFO]: Please consider upgrading to the latest version ($OnlineVersion) of $Module as soon as possible."
            return
        }

        if ($UninstallFirst -eq $true) {
            Write-Information "[INFO]: Uninstalling prior Module $Module version $InstalledVersion."
            try {
                Uninstall-Module -Name $Module -Force -Verbose:$False -ErrorAction Stop
            }
            catch {
                Write-Verbose "Failed to uninstall module $Module version $InstalledVersion. $_"
                return
            }
        }

        Write-Information "[INFO]: Installing newer Module $Module version $OnlineVersion."
        try {
            Install-Module -Name $Module -Force -AllowClobber -Verbose:$False -MinimumVersion $OnlineVersion -ErrorAction Stop
        }
        catch {
            Write-Verbose "Failed to install module $Module version $OnlineVersion. $_"
            return
        }

        try {
            Update-LogicMonitorSEModule -Module $Module -CheckOnly
        }
        catch {
            Write-Verbose "Post-installation verification failed for module $Module. $_"
        }
    }
    catch {
        Write-Verbose "Unexpected error encountered while updating module $Module. $_"
    }
}