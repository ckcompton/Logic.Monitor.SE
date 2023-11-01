Function Get-LMPOVActivityReport{
    Param(
        [String]$Portal ,

        [Int]$DaysOfActivity = 14
    )
    If($(Get-LMAccountStatus).Valid){
        $ActivityResult = [System.Collections.ArrayList]@()
        
        Write-Host "[INFO]: Collecting audit logs for $Portal."
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
    
        return $ActivityResult
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}