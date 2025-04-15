# 05_Classify-Data.ps1 - Runs classification using rganonymize

# === Pull Variables from Environment ===
# These values are expected to be set by the main Run-Autopilot.ps1 script or provided via environment variables
# Useful when running this step manually or in a CI/CD pipeline

$targetConnectionString = $env:targetConnectionString          # Full connection string to the target database
$output                 = $env:output                          # Output directory for classification/mapping results
$logLevel               = $env:logLevel                        # Log level for rganonymize (e.g., info, debug, error)

# Flags for automation
$autoContinue           = [System.Convert]::ToBoolean($env:autoContinue) 2>$null         # True = run in non-interactive mode
$acceptAllDefaults      = [System.Convert]::ToBoolean($env:acceptAllDefaults) 2>$null    # True = skip prompts, assume defaults

Write-Host "Creating classification.json in $output" -ForegroundColor DarkCyan

# === CLI Command Preview ===
Write-Host "> CLI Command Example:" -ForegroundColor Blue
Write-Host "  rganonymize classify --database-engine=sqlserver --connection-string=`"[REDACTED]`" --classification-file=`"$output\classification.json`" --output-all-columns --log-level=$logLevel" -ForegroundColor Blue
Write-Host ""

try {
    $rganonymizeArgs = @(
        'classify'
        '--database-engine=sqlserver'
        "--connection-string=$targetConnectionString"
        "--classification-file=$output\classification.json"
        '--output-all-columns'
        "--log-level=$logLevel"
    )

    & rganonymize @rganonymizeArgs | Tee-Object -Variable classifyOutput

    if ($LASTEXITCODE -ne 0 -or ($classifyOutput -match "ERROR")) {
        throw "rganonymize (Classify) failed with exit code $LASTEXITCODE."
    }

    Write-Host "Classification completed successfully." -ForegroundColor Green
} catch {
    Write-Error "Classification failed: $_"
    exit 1
}
