#!/bin/bash
# Make the script executable: chmod +x 02_rganonymize_classify.sh

# Classify data using rganonymize
# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# export DB_ENGINE="PostgreSql"
# export TARGET_CONN_STRING="Server=...;Database=...;..."
# ./02_rganonymize_classify.sh


# TDM Licensing Paramaters https://documentation.red-gate.com/testdatamanager/getting-started/licensing/activating-your-license
REDGATE_LICENSING_PAT_EMAIL=${REDGATE_LICENSING_PAT_EMAIL:-"MyEmailHere"}
REDGATE_LICENSING_PAT_KEY=${REDGATE_LICENSING_PAT_KEY:-"MyKeyHere"}

# Project directory and config path
PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-"/mnt/c/Redgate/GIT/Repos/GitHub/Autopilot/Development/TDM-Autopilot"}
PROJECT_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/Steps/Manual_CLI/Configuration"

# CLI parameters
DB_ENGINE=${DB_ENGINE:-"SqlServer"}
LOG_LEVEL=${LOG_LEVEL:-"Verbose"}

# Optional flags
TRUST_CERT=${TRUST_SERVER_CERTIFICATE:-"yes"}
ENCRYPT=${ENCRYPT:-"no"}

# Target connection
if [ -z "$TARGET_CONN_STRING" ]; then
    TARGET_HOST=${TARGET_HOST:-"127.0.0.1"}
    TARGET_PORT=${TARGET_PORT:-"1433"}
    TARGET_DB=${TARGET_DB:-"Autopilot_Treated"}
    TARGET_USER=${TARGET_USER:-"sa"}
    TARGET_PASSWORD=${TARGET_PASSWORD:-"Redg@te1"}
    TARGET_CONN_STRING="Server=$TARGET_HOST,$TARGET_PORT;Database=$TARGET_DB;Trust Server Certificate=$TRUST_CERT;Encrypt=$ENCRYPT;User ID=$TARGET_USER;Password=$TARGET_PASSWORD"
fi

CLASSIFICATION_FILE=${CLASSIFICATION_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/classification.json"}

# Toggle for loading environment variables
RELOAD_SERVER_VARS=${RELOAD_SERVER_VARS:-"yes"}

if [ "$RELOAD_SERVER_VARS" = "yes" ]; then
    echo "INFO: Loading environment variables from ~/.bashrc"
    source ~/.bashrc
else
    echo "INFO: Skipping environment variable loading from ~/.bashrc"
fi

echo "Running classification for database engine: $DB_ENGINE"

rganonymize classify \
  --database-engine "$DB_ENGINE" \
  --connection-string "$TARGET_CONN_STRING" \
  --classification-file "$CLASSIFICATION_FILE" \
  --output-all-columns \
  --log-level "$LOG_LEVEL"