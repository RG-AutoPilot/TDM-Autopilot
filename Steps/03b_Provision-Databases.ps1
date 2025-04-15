# 03_Provision-Databases.ps1 - Restore or create databases for TDM processing

# === Fetch Parameters from Environment Variables ===

# SQL Server instance and database names
$sqlInstance        = $env:sqlInstance
$sqlUser            = $env:sqlUser
$sqlPassword        = $env:sqlPassword
$sourceDb           = $env:sourceDb
$targetDb           = $env:targetDb

# Backup and sample database-related inputs
$backupPath               = $env:backupPath
$sampleDatabase           = $env:sampleDatabase
$schemaCreateScript       = $env:schemaCreateScript
$productionDataInsertScript = $env:productionDataInsertScript
$testDataInsertScript     = $env:testDataInsertScript

# Boolean flags (with error suppression in case of unset/invalid values)
$noRestore         = [System.Convert]::ToBoolean($env:noRestore) 2>$null   # Skip provisioning if true
$winAuth           = [System.Convert]::ToBoolean($env:winAuth) 2>$null     # Use Windows Auth if true
$autoContinue      = [System.Convert]::ToBoolean($env:autoContinue) 2>$null # Non-interactive mode
$acceptAllDefaults = [System.Convert]::ToBoolean($env:acceptAllDefaults) 2>$null # Assume default answers for prompts


# If noRestore is true, skip this step
if ($noRestore) {
    Write-Host "INFO: Skipping database provisioning as -noRestore is set." -ForegroundColor Yellow
    return
}

if (([string]::IsNullOrWhiteSpace($sqlUser) -or [string]::IsNullOrWhiteSpace($sqlPassword))) {
    Write-Host "INFO: Utilizing SQL Auth Credentials"
    $SqlCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sqlUser, $sqlPassword
}

Write-Host "INFO: Beginning database provisioning..." -ForegroundColor DarkCyan

if ($backupPath) {
    Write-Host "INFO: Restoring databases from backup: $backupPath" -ForegroundColor Cyan
    Restore-StagingDatabasesFromBackup -WinAuth:$winAuth -sqlInstance:$sqlInstance -sourceDb:$sourceDb -targetDb:$targetDb -sourceBackupPath:$backupPath -SqlCredential:$SqlCredential
    return
}

if ($sampleDatabase -eq "Autopilot_Full") {
    Write-Host "INFO: Creating full Autopilot suite of databases..." -ForegroundColor Cyan
    New-SampleDatabasesAutopilotFull -WinAuth:$winAuth -sqlInstance:$sqlInstance -sourceDb:$sourceDb -targetDb:$targetDb -schemaCreateScript:$schemaCreateScript -productionDataInsertScript:$productionDataInsertScript -testDataInsertScript:$testDataInsertScript -SqlCredential:$SqlCredential
    return
}

if ($sampleDatabase -eq "Autopilot") {
    Write-Host "INFO: Creating standard Autopilot databases..." -ForegroundColor Cyan
    Write-Host "DEBUG: New-SampleDatabasesAutopilot -WinAuth:$winAuth -sqlInstance:$sqlInstance -sourceDb:$sourceDb -targetDb:$targetDb -schemaCreateScript:$schemaCreateScript -productionDataInsertScript:$productionDataInsertScript -testDataInsertScript:$testDataInsertScript -SqlCredential:$SqlCredential"

    New-SampleDatabasesAutopilot -WinAuth:$winAuth -sqlInstance:$sqlInstance -sourceDb:$sourceDb -targetDb:$targetDb -schemaCreateScript:$schemaCreateScript -productionDataInsertScript:$productionDataInsertScript -testDataInsertScript:$testDataInsertScript -SqlCredential:$SqlCredential
    return
}

# Fallback generic creation
Write-Host "INFO: Creating fallback Autopilot databases..." -ForegroundColor Cyan
New-SampleDatabasesAutopilot -WinAuth:$winAuth -sqlInstance:$sqlInstance -sourceDb:$sourceDb -targetDb:$targetDb -schemaCreateScript:$schemaCreateScript -productionDataInsertScript:$productionDataInsertScript -testDataInsertScript:$testDataInsertScript -SqlCredential:$SqlCredential
