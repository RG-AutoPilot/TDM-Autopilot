#!/bin/bash
# filepath: c:\Redgate\GIT\Repos\GitHub\Autopilot\Development\TDM-Autopilot\Steps\Manual_CLI\Linux\03_rganonymize_map.sh

# Map data using rganonymize
# This script uses hardcoded values by default.
# You can override any value by setting an environment variable before running the script.
# Example:
# export CLASSIFICATION_FILE="path/to/classification.json"
# export MASKING_FILE="path/to/masking.json"
# ./03_rganonymize_map.sh

# Project directory and config path
PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-"/mnt/c/Redgate/GIT/Repos/GitHub/Autopilot/Development/TDM-Autopilot"}
PROJECT_CONFIGURATION_DIRECTORY="$PROJECT_DIRECTORY/Steps/Manual_CLI/Configuration"

CLASSIFICATION_FILE=${CLASSIFICATION_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/classification.json"}
MASKING_FILE=${MASKING_FILE:-"$PROJECT_CONFIGURATION_DIRECTORY/masking.json"}

echo "Running mapping from classification file to masking file"

rganonymize map \
  --classification-file "$CLASSIFICATION_FILE" \
  --masking-file "$MASKING_FILE"