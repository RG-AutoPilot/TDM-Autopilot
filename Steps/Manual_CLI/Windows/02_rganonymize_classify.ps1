# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# $env:DB_ENGINE = "PostgreSql"
# $env:TARGET_CONN_STRING = "Server=...;Database=...;..."
# .\ScriptName.ps1

# Project directory and config path
$PROJECT_DIRECTORY = if ($env:PROJECT_DIRECTORY) { $env:PROJECT_DIRECTORY } else { "C:\git\Demos\TDM-AutoPilot" }
$PROJECT_CONFIGURATION_DIRECTORY = Join-Path $PROJECT_DIRECTORY "Steps\Manual_CLI\Configuration"

# CLI parameters
$DB_ENGINE    = if ($env:DB_ENGINE)    { $env:DB_ENGINE }    else { "SqlServer" }
$LOG_LEVEL    = if ($env:LOG_LEVEL)    { $env:LOG_LEVEL }    else { "Verbose" }

# Optional flags
$TRUST_CERT = if ($env:TRUST_SERVER_CERTIFICATE) { $env:TRUST_SERVER_CERTIFICATE } else { "yes" }
$ENCRYPT    = if ($env:ENCRYPT)                  { $env:ENCRYPT }                  else { "no" }

# Target connection
$TARGET_CONN_STRING = if ($env:TARGET_CONN_STRING) {
    $env:TARGET_CONN_STRING
} else {
    $TARGET_HOST     = if ($env:TARGET_HOST)     { $env:TARGET_HOST }     else { "127.0.0.1" }
    $TARGET_PORT     = if ($env:TARGET_PORT)     { $env:TARGET_PORT }     else { "1433" }
    $TARGET_DB       = if ($env:TARGET_DB)       { $env:TARGET_DB }       else { "Autopilot_Treated" }
    $TARGET_USER     = if ($env:TARGET_USER)     { $env:TARGET_USER }     else { "Redgate" }
    $TARGET_PASSWORD = if ($env:TARGET_PASSWORD) { $env:TARGET_PASSWORD } else { "Redg@te1" }
    "Server=$TARGET_HOST,$TARGET_PORT;Database=$TARGET_DB;Trust Server Certificate=$TRUST_CERT;Encrypt=$ENCRYPT;User ID=$TARGET_USER;Password=$TARGET_PASSWORD"
}

$CLASSIFICATION_FILE = if ($env:CLASSIFICATION_FILE) { $env:CLASSIFICATION_FILE } else { Join-Path $PROJECT_CONFIGURATION_DIRECTORY "classification.json" }

Write-Host "Running classification for database engine: $DB_ENGINE"

rganonymize classify `
  --database-engine $DB_ENGINE `
  --connection-string "$TARGET_CONN_STRING" `
  --classification-file $CLASSIFICATION_FILE `
  --output-all-columns `
  --log-level $LOG_LEVEL
