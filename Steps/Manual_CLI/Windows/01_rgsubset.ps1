# Subset data using rgsubset
# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# $env:DB_ENGINE = "PostgreSql"
# $env:SOURCE_CONN_STRING = "Server=...;Database=...;..."
# .\Subset_Data.ps1

# Project directory and config path
$PROJECT_DIRECTORY = if ($env:PROJECT_DIRECTORY) { $env:PROJECT_DIRECTORY } else { "C:\git\Demos\TDM-AutoPilot" }
$PROJECT_CONFIGURATION_DIRECTORY = Join-Path $PROJECT_DIRECTORY "Steps\Manual_CLI\Configuration"

# CLI parameters
$DB_ENGINE    = if ($env:DB_ENGINE)    { $env:DB_ENGINE }    else { "SqlServer" }
$OPTIONS_FILE = if ($env:OPTIONS_FILE) { $env:OPTIONS_FILE } else { Join-Path $PROJECT_CONFIGURATION_DIRECTORY "rgsubset-options-autopilot.json" }
$OUTPUT_FILE  = if ($env:OUTPUT_FILE)  { $env:OUTPUT_FILE }  else { Join-Path $PROJECT_CONFIGURATION_DIRECTORY "subset_Log.json" }
$LOG_LEVEL    = if ($env:LOG_LEVEL)    { $env:LOG_LEVEL }    else { "Verbose" }

# Optional flags
$TRUST_CERT = if ($env:TRUST_SERVER_CERTIFICATE) { $env:TRUST_SERVER_CERTIFICATE } else { "yes" }
$ENCRYPT    = if ($env:ENCRYPT)                  { $env:ENCRYPT }                  else { "no" }

# Source connection
$SOURCE_CONN_STRING = if ($env:SOURCE_CONN_STRING) {
    $env:SOURCE_CONN_STRING
} else {
    $SOURCE_HOST     = if ($env:SOURCE_HOST)     { $env:SOURCE_HOST }     else { "127.0.0.1" }
    $SOURCE_PORT     = if ($env:SOURCE_PORT)     { $env:SOURCE_PORT }     else { "1433" }
    $SOURCE_DB       = if ($env:SOURCE_DB)       { $env:SOURCE_DB }       else { "AutopilotProd_FullRestore" }
    $SOURCE_USER     = if ($env:SOURCE_USER)     { $env:SOURCE_USER }     else { "Redgate" }
    $SOURCE_PASSWORD = if ($env:SOURCE_PASSWORD) { $env:SOURCE_PASSWORD } else { "Redg@te1" }
    "Server=$SOURCE_HOST,$SOURCE_PORT;Database=$SOURCE_DB;Trust Server Certificate=$TRUST_CERT;Encrypt=$ENCRYPT;User ID=$SOURCE_USER;Password=$SOURCE_PASSWORD"
}

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

Write-Host "Running subset for database engine: $DB_ENGINE"

rgsubset run `
  --database-engine $DB_ENGINE `
  --source-connection-string "$SOURCE_CONN_STRING" `
  --target-connection-string "$TARGET_CONN_STRING" `
  --target-database-write-mode Overwrite `
  --options-file $OPTIONS_FILE `
  --log-level $LOG_LEVEL `
  --output-file $OUTPUT_FILE
