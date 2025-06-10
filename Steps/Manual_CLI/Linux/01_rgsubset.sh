#!/bin/bash
# Make the script executable: chmod +x 01_rgsubset.sh

# Subset data using rgsubset
# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# export DB_ENGINE="PostgreSql"
# export SOURCE_CONN_STRING="Server=...;Database=...;..."
# ./01_rgsubset.sh

# TDM Licensing Paramaters https://documentation.red-gate.com/testdatamanager/getting-started/licensing/activating-your-license
REDGATE_LICENSING_PAT_EMAIL=${REDGATE_LICENSING_PAT_EMAIL:-"MyEmailHere"}
REDGATE_LICENSING_PAT_KEY=${REDGATE_LICENSING_PAT_KEY:-"MyKeyHere"}

# Project directory and config path
PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-"/mnt/c/Redgate/GIT/Repos/GitHub/Autopilot/Development/TDM-Autopilot"}
PROJECT_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/Steps/Manual_CLI/Configuration"

# CLI parameters
DB_ENGINE=${DB_ENGINE:-"SqlServer"}
OPTIONS_FILE=${OPTIONS_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/rgsubset-options-autopilot.json"}
OUTPUT_FILE=${OUTPUT_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/subset_Log.json"}
LOG_LEVEL=${LOG_LEVEL:-"Verbose"}

# Optional flags
TRUST_CERT=${TRUST_SERVER_CERTIFICATE:-"yes"}
ENCRYPT=${ENCRYPT:-"no"}

# Source connection
if [ -z "$SOURCE_CONN_STRING" ]; then
    SOURCE_HOST=${SOURCE_HOST:-"127.0.0.1"}
    SOURCE_PORT=${SOURCE_PORT:-"1433"}
    SOURCE_DB=${SOURCE_DB:-"AutopilotProd_FullRestore"}
    SOURCE_USER=${SOURCE_USER:-"sa"}
    SOURCE_PASSWORD=${SOURCE_PASSWORD:-"Redg@te1"}
    SOURCE_CONN_STRING="Server=$SOURCE_HOST,$SOURCE_PORT;Database=$SOURCE_DB;Trust Server Certificate=$TRUST_CERT;Encrypt=$ENCRYPT;User ID=$SOURCE_USER;Password=$SOURCE_PASSWORD"
fi

# Target connection
if [ -z "$TARGET_CONN_STRING" ]; then
    TARGET_HOST=${TARGET_HOST:-"127.0.0.1"}
    TARGET_PORT=${TARGET_PORT:-"1433"}
    TARGET_DB=${TARGET_DB:-"Autopilot_Treated"}
    TARGET_USER=${TARGET_USER:-"sa"}
    TARGET_PASSWORD=${TARGET_PASSWORD:-"Redg@te1"}
    TARGET_CONN_STRING="Server=$TARGET_HOST,$TARGET_PORT;Database=$TARGET_DB;Trust Server Certificate=$TRUST_CERT;Encrypt=$ENCRYPT;User ID=$TARGET_USER;Password=$TARGET_PASSWORD"
fi

# Toggle for loading environment variables
RELOAD_SERVER_VARS=${RELOAD_SERVER_VARS:-"yes"}

if [ "$RELOAD_SERVER_VARS" = "yes" ]; then
    echo "INFO: Loading environment variables from ~/.bashrc"
    source ~/.bashrc
else
    echo "INFO: Skipping environment variable loading from ~/.bashrc"
fi

echo "Running subset for database engine: $DB_ENGINE"

rgsubset run \
  --database-engine "$DB_ENGINE" \
  --source-connection-string "$SOURCE_CONN_STRING" \
  --target-connection-string "$TARGET_CONN_STRING" \
  --target-database-write-mode Overwrite \
  --options-file "$OPTIONS_FILE" \
  --log-level "$LOG_LEVEL" \
  --output-file "$OUTPUT_FILE"