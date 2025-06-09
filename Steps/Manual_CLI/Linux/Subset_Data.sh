#!/bin/bash
# Subset data using rgsubset
# Usage: ./04_subset_data.sh
# You can override any variable below using environment variables

# Database engine (SqlServer, Oracle, PostgreSQL, MySQL)
DB_ENGINE="${DB_ENGINE:-SqlServer}"

# File paths (relative to Manual_CLI/Configuration)
OPTIONS_FILE="${OPTIONS_FILE:-../Configuration/options.json}"
OUTPUT_FILE="${OUTPUT_FILE:-../Configuration/Subset_Log.json}"
LOG_LEVEL="${LOG_LEVEL:-Verbose}"

# Source DB connection
SOURCE_HOST="${SOURCE_HOST:-127.0.0.1}"
SOURCE_PORT="${SOURCE_PORT:-1433}"
SOURCE_DB="${SOURCE_DB:-AutopilotProd_FullRestore}"
SOURCE_USER="${SOURCE_USER:-sa}"
SOURCE_PASSWORD="${SOURCE_PASSWORD:-Redg@te1}"

# Target DB connection
TARGET_HOST="${TARGET_HOST:-127.0.0.1}"
TARGET_PORT="${TARGET_PORT:-1433}"
TARGET_DB="${TARGET_DB:-Autopilot_Treated}"
TARGET_USER="${TARGET_USER:-sa}"
TARGET_PASSWORD="${TARGET_PASSWORD:-Redg@te1}"

echo "Running subset for $DB_ENGINE..."
rgsubset run \
  --database-engine "$DB_ENGINE" \
  --source-connection-string "Server=$SOURCE_HOST,$SOURCE_PORT;Database=$SOURCE_DB;Trust Server Certificate=yes;User ID=$SOURCE_USER;Password=$SOURCE_PASSWORD" \
  --target-connection-string "Server=$TARGET_HOST,$TARGET_PORT;Database=$TARGET_DB;Trust Server Certificate=yes;User ID=$TARGET_USER;Password=$TARGET_PASSWORD" \
  --target-database-write-mode Overwrite \
  --options-file "$OPTIONS_FILE" \
  --log-level "$LOG_LEVEL" \
  --output-file "$OUTPUT_FILE"
