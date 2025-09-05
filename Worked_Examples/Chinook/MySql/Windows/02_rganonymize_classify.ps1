# Classify data using rganonymize
# This script demonstrates how to run the rganonymize CLI command with example values.
# For more details, visit: https://documentation.red-gate.com/testdatamanager
#
# Key Options:
#   --database-engine: The database engine to use (e.g., SqlServer, PostgreSql).
#   --connection-string: Connection string for the database.
#   --classification-file: Path to the JSON file containing classification rules.
#   --log-level: Logging level (e.g., Verbose, Info, Error).

# Example values
$DB_ENGINE = "MySql"
$CONNECTION_STRING = "Server=localhost;Port=3306;Database=chinook-treated;Uid=root;Pwd=Redg@te1"
$CLASSIFICATION_FILE = "..\classification.json"
$OPTIONS_FILE = "..\masking-options.json"
$LOG_LEVEL = "Verbose"
$OUTPUT = "Human" # Human|Json

Write-Host "Running classification for database engine: $DB_ENGINE"

rganonymize classify `
  --database-engine $DB_ENGINE `
  --connection-string "$CONNECTION_STRING" `
  --classification-file $CLASSIFICATION_FILE `
  --options-file "$OPTIONS_FILE" `
  --output-all-columns `
  --log-level $LOG_LEVEL `
  --output $OUTPUT