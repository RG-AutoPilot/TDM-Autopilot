# 07_Mask-Data.ps1 - Applies masking using rganonymize

# === Pull Variables from Environment ===
# These are set by Run-Autopilot.ps1 or passed in from a CI/CD pipeline.

$targetConnectionString = $env:targetConnectionString        # Full connection string for the target database
$targetDb               = $env:targetDb                      # Name of the target (subsetted) database
$output                 = $env:output                        # Directory to write log and output files
$logLevel               = $env:logLevel                      # Verbosity level for CLI tools (e.g., info, warn, error)

# === Masking Step ===
Write-Host "Applying masking to database '$targetDb' using: $output\masking.json" -ForegroundColor DarkCyan

# === Build Real CLI Arguments ===
$maskArgs = @(
    'mask'
    '--database-engine=sqlserver'
    "--connection-string=$targetConnectionString"
    "--masking-file=$output\masking.json"
    "--log-level=$logLevel"
)

# === Redact Sensitive Information ===
$previewArgs = $maskArgs.ForEach({
    if ($_ -like "--connection-string=*") {
        return ($_ -replace '(?i)(Password|Pwd)=.*?(;|$)', '${1}=[REDACTED]$2')
    }
    return $_
})

# === CLI Command Preview ===
Write-Host "`n> CLI Command Example:" -ForegroundColor Blue
Write-Host "  rganonymize $($previewArgs -join ' ')" -ForegroundColor Blue
Write-Host ""

try {
    & rganonymize @maskArgs | Tee-Object -Variable maskOutput

    if ($LASTEXITCODE -ne 0 -or ($maskOutput -match "ERROR")) {
        throw "rganonymize (Mask) failed with exit code $LASTEXITCODE."
    }

    Write-Host "Masking completed successfully." -ForegroundColor Green
} catch {
    Write-Error "Masking failed: $_"
    exit 1
}
