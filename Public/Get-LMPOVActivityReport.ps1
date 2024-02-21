<#
.SYNOPSIS
Generate list of active users in a portal along with associated activities.

.DESCRIPTION
Generate list of active users in a portal along with associated activities.

.EXAMPLE
Get-LMPOVActivityReport -DaysOfActivity 30

.NOTES
Must be connected to the portal you want to pull activity reports from ahead of time.

.INPUTS
None. Does not accept pipeline input

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor.SE

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor.SE
#>
Function Get-LMPOVActivityReport{
    Param(
        [Int]$DaysOfActivity = 14
    )
    If($(Get-LMAccountStatus).Valid){
        $ActivityResult = [System.Collections.ArrayList]@()
        $Portal = $($(Get-LMAccountStatus).Portal)
        
        Write-Host "[INFO]: Collecting audit logs for $Portal for the last $DaysOfActivity days."
        $AuditLogs = Get-LMAuditLogs -StartDate $((Get-Date).AddDays(-$DaysOfActivity)) -EndDate $(Get-Date)
        If($AuditLogs){
            Write-Host "[INFO]: Parsing through $(($AuditLogs | Measure-Object).Count) log entries."
            $Grouping = $AuditLogs | Where-Object {$_.username -like "*@*"} | Group-Object -Property username
    
            Write-Host "[INFO]: Found through $(($Grouping | Measure-Object).Count) active users."
            Foreach ($User in $Grouping){
                $SignIns = $User.Group | Where-Object {$_.description -like "*signs in*" -or $_.description -like "*log in*"}
                $ActivityResult.Add([PSCustomObject]@{
                    Portal = $Portal
                    UserName = $User.Name
                    ActivityCount = $User.Count
                    NumberOfLogins = ($SignIns | Measure-Object).Count
                    LatestLogin = ($SignIns | Sort-Object -Property happenedOn -Descending | Select-Object -First 1).happenedOnLocal
                    ActivityPeriod = "$DaysOfActivity days"
                    Activities = $User.Group
                }) | Out-Null
            }
            If(!$Grouping){
                $ActivityResult.Add([PSCustomObject]@{
                    Portal = $Portal
                    UserName = "N/A"
                    ActivityCount = 0
                    NumberOfLogins = 0
                    LatestLogin = "No activity detected"
                    ActivityPeriod = "$DaysOfActivity days"
                    Activities = $null
                }) | Out-Null
            }
        }
        Write-Host "[INFO]: Audit log activity collected for $Portal.`n"
    
        Return (Add-ObjectTypeInfo -InputObject $ActivityResult -TypeName "LogicMonitor.ActivityResults" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}