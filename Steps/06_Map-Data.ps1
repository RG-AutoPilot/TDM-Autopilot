# 06_Map-Data.ps1 - Runs mapping using rganonymize

# === Pull Variables from Environment ===
# These values are typically set by Run-Autopilot.ps1 or passed via CI/CD pipelines.
# Ensure these are set before running manually.

$output               = $env:output                          # Output directory where logs/results should be saved
$logLevel             = $env:logLevel                        # Log verbosity for the current step (e.g., info, debug, error)

# === Mapping Step ===
Write-Host "Creating masking.json from classification.json in $output" -ForegroundColor DarkCyan

# === CLI Command Preview ===
Write-Host "> CLI Command Example:" -ForegroundColor Blue
Write-Host "  rganonymize map --classification-file=`"$output\classification.json`" --masking-file=`"$output\masking.json`" --log-level=$logLevel" -ForegroundColor Blue
Write-Host "" 

try {
    $mapArgs = @(
        'map'
        "--classification-file=$output\classification.json"
        "--masking-file=$output\masking.json"
        "--log-level=$logLevel"
    )

    & rganonymize @mapArgs | Tee-Object -Variable mapOutput

    if ($LASTEXITCODE -ne 0 -or ($mapOutput -match "ERROR")) {
        throw "rganonymize (Map) failed with exit code $LASTEXITCODE."
    }

    Write-Host "Mapping completed successfully." -ForegroundColor Green
} catch {
    Write-Error "Mapping failed: $_"
    exit 1
}
