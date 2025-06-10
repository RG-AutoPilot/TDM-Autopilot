#!/bin/bash
# Make the script executable: chmod +x 03_rganonymize_map.sh

# Map data using rganonymize
# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# export CLASSIFICATION_FILE="path/to/classification.json"
# export MASKING_FILE="path/to/masking.json"
# ./03_rganonymize_map.sh


# TDM Licensing Paramaters https://documentation.red-gate.com/testdatamanager/getting-started/licensing/activating-your-license
REDGATE_LICENSING_PAT_EMAIL=${REDGATE_LICENSING_PAT_EMAIL:-"MyEmailHere"}
REDGATE_LICENSING_PAT_KEY=${REDGATE_LICENSING_PAT_KEY:-"MyKeyHere"}

# Project directory and config path
PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-"/mnt/c/Redgate/GIT/Repos/GitHub/Autopilot/Development/TDM-Autopilot"}
PROJECT_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/Steps/Manual_CLI/Configuration"

CLASSIFICATION_FILE=${CLASSIFICATION_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/classification.json"}
MASKING_FILE=${MASKING_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/masking.json"}

# Toggle for loading environment variables
RELOAD_SERVER_VARS=${RELOAD_SERVER_VARS:-"yes"}

if [ "$RELOAD_SERVER_VARS" = "yes" ]; then
    echo "INFO: Loading environment variables from ~/.bashrc"
    source ~/.bashrc
else
    echo "INFO: Skipping environment variable loading from ~/.bashrc"
fi

echo "Running mapping from classification file to masking file"

rganonymize map \
  --classification-file "$CLASSIFICATION_FILE" \
  --masking-file "$MASKING_FILE"