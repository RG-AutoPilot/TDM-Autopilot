# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# $env:CLASSIFICATION_FILE = "path\to\classification.json"
# $env:MASKING_FILE = "path\to\masking.json"
# .\Map_Data.ps1

# Project directory and config path
$PROJECT_DIRECTORY = if ($env:PROJECT_DIRECTORY) { $env:PROJECT_DIRECTORY } else { "C:\git\Demos\TDM-AutoPilot" }
$PROJECT_CONFIGURATION_DIRECTORY = Join-Path $PROJECT_DIRECTORY "Steps\Manual_CLI\Configuration"

$CLASSIFICATION_FILE = if ($env:CLASSIFICATION_FILE) { $env:CLASSIFICATION_FILE } else { Join-Path $PROJECT_CONFIGURATION_DIRECTORY "classification.json" }
$MASKING_FILE        = if ($env:MASKING_FILE)        { $env:MASKING_FILE }        else { Join-Path $PROJECT_CONFIGURATION_DIRECTORY "masking.json" }

Write-Host "Running mapping from classification to masking file"

rganonymize map `
  --classification-file $CLASSIFICATION_FILE `
  --masking-file $MASKING_FILE
