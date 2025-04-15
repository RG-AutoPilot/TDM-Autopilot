# Run-Autopilot.ps1

###################################################################################################
# Pre-Reqs: IMPORT PARAMETERS (OPTIONAL)
###################################################################################################

param (
    [string]$sqlInstance,
    [string]$sqlUser,
    [string]$sqlPassword,
    [string]$configFile
)

###################################################################################################
# Pre-Reqs: IMPORT FUNCTIONS
###################################################################################################
function Prompt-ToContinue($message) {
    $autoContinue = [System.Convert]::ToBoolean([System.Environment]::GetEnvironmentVariable("autoContinue"))
    if ($autoContinue) {
        return $true
    }

    Write-Host "$message" -ForegroundColor Yellow
    $response = Read-Host
    $cleanResponse = if ([string]::IsNullOrWhiteSpace($response)) { "Y" } else { $response.Trim().ToUpper() }

    if ($cleanResponse -eq 'Y') {
        return $true
    } else {
        Write-Host "Skipping step as per user input..." -ForegroundColor Yellow
        return $false
    }
}

###################################################################################################
# SELECT CONFIG FILE: Accept as param or prompt (Default, Full, or Backup)
###################################################################################################

$availableConfigs = @(
    'Autopilot-Configuration_Default.conf',
    'Autopilot-Configuration_Full.conf',
    'Autopilot-Configuration_Backup.conf'
)

$configFolder = Join-Path $PSScriptRoot 'Config_Files'


# If configFile param was passed, use it silently (e.g., from CI/CD)
if ($configFile) {
    Write-Host "Config file passed in as param: $configFile" -ForegroundColor Green

} elseif ($autoContinue) {
    $configFile = 'Autopilot-Configuration_Automation.conf'
    Write-Host "Auto mode: Using Default Automation Config ($configFile)" -ForegroundColor DarkCyan

} else {
    Write-Host "Available configuration files:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $availableConfigs.Count; $i++) {
        Write-Host "[$i] $($availableConfigs[$i])"
    }

    Write-Host "" -NoNewline
    Write-Host "> Enter the number of the config file to use [Default: 0]:" -ForegroundColor Yellow
    $selection = Read-Host
    if ([string]::IsNullOrWhiteSpace($selection)) { $selection = "0" }

    if ($selection -match '^[0-2]$') {
        $configFile = $availableConfigs[$selection]
    } else {
        $configFile = 'Autopilot-Configuration_Default.conf'
        Write-Host "Invalid selection. Defaulting to $configFile" -ForegroundColor Yellow
    }

    Write-Host "Selected config: $configFile" -ForegroundColor Green
}

###################################################################################################
# LOAD SELECTED CONFIG AND SHOW PREVIEW
###################################################################################################

$configPath = Join-Path $configFolder $configFile
if (-not (Test-Path $configPath)) {
    Write-Error "Missing config file: $configPath"
    exit 1
}

# Load config from file
$config = @{}
Get-Content $configPath | ForEach-Object {
    $_ = $_.Trim()
    if (-not $_ -or $_.StartsWith("#")) { return }
    if ($_ -match '^(.*?)\s*=\s*(.*?)(\s*#.*)?$') {
        $key = $matches[1].Trim()
        $val = $matches[2].Trim()

        if ($val.StartsWith('"') -and $val.EndsWith('"')) {
            $val = $val.Substring(1, $val.Length - 2)
        }

        $config[$key] = $val
    }
}

# Apply config values only if no param was passed
foreach ($key in $config.Keys) {
    $paramWasSet = Get-Variable -Name $key -Scope Script -ErrorAction SilentlyContinue
    $paramValue = if ($paramWasSet) { (Get-Variable -Name $key -Scope Script).Value } else { $null }

    if ([string]::IsNullOrWhiteSpace($paramValue)) {
        # Use value from config
        [System.Environment]::SetEnvironmentVariable($key, $config[$key])
    }
    else {
        # Use passed-in value
        [System.Environment]::SetEnvironmentVariable($key, $paramValue)
    }
}

# === Preview final values ===
Write-Host "Configuration Preview:" -ForegroundColor DarkCyan

Write-Host "  - Target SQL Instance:             $($env:sqlInstance)" -ForegroundColor DarkCyan
Write-Host "  - Source Database:                 $($env:sourceDb)" -ForegroundColor DarkCyan
Write-Host "  - Target Database:                 $($env:targetDb)" -ForegroundColor DarkCyan

if (-not [string]::IsNullOrWhiteSpace($env:backupPath)) {
    Write-Host "  - Backup Path:                     $($env:backupPath)" -ForegroundColor DarkCyan
}

if ([string]::IsNullOrWhiteSpace($env:sqlUser)) {
    Write-Host "  - Use Windows Authentication?:     true" -ForegroundColor DarkCyan
} else {
    Write-Host "  - Use Windows Authentication?:     false" -ForegroundColor DarkCyan
    Write-Host "  - Username:                        $($env:sqlUser)" -ForegroundColor DarkCyan
}

Write-Host "  - Trust Server Certificate?:       $($env:trustCert)" -ForegroundColor DarkCyan
Write-Host "  - Encrypt Connection?:             $($env:encryptConnection)" -ForegroundColor DarkCyan
Write-Host "  - Skip Database Creation?:         $($env:noRestore)" -ForegroundColor DarkCyan
Write-Host ""

# === Confirm before continuing ===
if (-not $autoContinue) {
    if (-not (Prompt-ToContinue "> Do you want to continue with this configuration? (Y/N)")) {
        Write-Error "User aborted after reviewing configuration."
        exit 1
    }
}

###################################################################################################
# DETECT POWERSHELL EDITION
###################################################################################################

$isPwsh = $PSVersionTable.PSEdition -eq "Core"
Write-Host "INFO: Detected PowerShell Edition: $($PSVersionTable.PSEdition)" -ForegroundColor DarkCyan


###################################################################################################
# REDGATE EULA AGREEMENT
###################################################################################################

if (-not $iAgreeToTheRedgateEula){
    Prompt-ToContinue "> Do you agree to the Redgate End User License Agreement (EULA)? (Y/N)"
}

###################################################################################################
# SET BOOLEAN ENVIRONMENT VARIABLES EXPLICITLY
###################################################################################################

$boolKeys = @( # These need to be converted from strings to actual Booleans for condition checks
    'autoContinue',         # Automatically continue without user interaction (CI/CD mode)
    'acceptAllDefaults',    # Assume default choices for interactive questions
    'noRestore'             # Skip database provisioning step if databases already exist
)
foreach ($key in $boolKeys) {
    if ($config.ContainsKey($key)) {
        $cleanVal = $config[$key] -replace '\s*#.*$',''  # Strip inline comments
        $boolVal = [System.Convert]::ToBoolean($cleanVal.Trim())
        [System.Environment]::SetEnvironmentVariable($key, $boolVal)
    }
}

# Set the root folder as an env var so step scripts can access it
[System.Environment]::SetEnvironmentVariable("TDM_AUTOPILOT_ROOT", $PSScriptRoot)

###################################################################################################
# CREATE TIMESTAMPED OUTPUT FOLDER AND CLEANUP PREVIOUS OUTPUT
###################################################################################################

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $env:output $timestamp
[System.Environment]::SetEnvironmentVariable("output", $output)

$parentOutput = Split-Path $output -Parent
if (Test-Path $parentOutput) {
    Write-Host "INFO: Attempting to delete existing output directory..." -ForegroundColor DarkCyan
    try {
        Remove-Item -Recurse -Force $parentOutput -ErrorAction Stop | Out-Null
        Write-Host "Successfully cleaned the output directory." -ForegroundColor Green
    } 
    catch {
        Write-Host "INFO: Skipping cleanup due to insufficient permissions. Previous subfolders may remain in '$parentOutput'" -ForegroundColor DarkCyan
    }
}

if (-not (Test-Path $output)) {
    Write-Host "INFO: Creating output directory: $output" -ForegroundColor DarkCyan
    try {
        New-Item -ItemType Directory -Path $output -Force | Out-Null
        Write-Host "Output directory created." -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: Failed to create output directory '$output'" -ForegroundColor Red
        Write-Host "Please check permissions or specify a different path using -output." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "INFO: Output directory already exists: $output" -ForegroundColor Yellow
}

###################################################################################################
# STEP 1: INSTALL REDGATE TDM CLI TOOLS
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 1: Install Redgate TDM CLI Tools (rgsubset, rganonymize)" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

Prompt-ToContinue "> Validate and Install the Latest TDM CLIs? (Y/N)"

& "$PSScriptRoot/Steps/01_Install-TDMCLI.ps1"

###################################################################################################
# STEP 2: INSTALL DBATOOLS
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 2: Install dbatools module if needed" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

Prompt-ToContinue "> Validate and Install the dbatools Module? (Y/N)"

& "$PSScriptRoot/Steps/02_Install-DbaTools.ps1"

###################################################################################################
# STEP 3.1: BUILD CONNECTION STRINGS BASED ON AUTH TYPE
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 3.a: Build connection strings" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

& "$PSScriptRoot/Steps/03a_Create-ConnectionStrings.ps1"

###################################################################################################
# STEP 3.2: PROVISION DATABASES (SKIP IF noRestore = true)
###################################################################################################
$noRestore = [System.Convert]::ToBoolean([System.Environment]::GetEnvironmentVariable("noRestore"))
if (-not $noRestore) {
    Write-Host "=============================================================================================" -ForegroundColor Blue
    Write-Host "STEP 3b: Provision Databases from scripts or backup" -ForegroundColor Cyan
    Write-Host "=============================================================================================" -ForegroundColor Blue

    $proceed = Prompt-ToContinue "> Proceed with provisioning sample databases? (Y/N)"
    if ($proceed) {
        try {
            & "$PSScriptRoot/Steps/03b_Provision-Databases.ps1"
            if ($LASTEXITCODE -ne 0) {
                throw "Provisioning script failed with exit code $LASTEXITCODE"
            }
        } catch {
            Write-Error "Step failed: $_"
            exit 1
        }
    }
} else {
    Write-Host "Skipping STEP 3 (Provision Databases) because 'noRestore' is set to true." -ForegroundColor Yellow
}

###################################################################################################
# AUTHENTICATE CLI TOOLS (unless skipped)
###################################################################################################

Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "Pre-Req: TDM: Data Treatments - Authentication" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

if (-not $skipAuth) {
    # Check for offline permit using both User and Machine scopes
    $offlinePermitPath = [Environment]::GetEnvironmentVariable("REDGATE_LICENSING_PERMIT_PATH", "User")
    if (-not $offlinePermitPath) {
        $offlinePermitPath = [Environment]::GetEnvironmentVariable("REDGATE_LICENSING_PERMIT_PATH", "Machine")
    }

    $skipBecauseOfPermit = $false

    if ($offlinePermitPath) {
        Write-Host "INFO: Offline permit detected at: $offlinePermitPath" -ForegroundColor Yellow

        if (-not $autoContinue) {
            do {
                Write-Host "> Do you want to skip online login and use the offline permit? (Y/N) [Default: Y]" -ForegroundColor Yellow
                $permitResponse = Read-Host
                $permitResponse = if ([string]::IsNullOrWhiteSpace($permitResponse)) { "Y" } else { $permitResponse.Trim().ToUpper() }
            } until ($permitResponse -match "^(Y|N)$")

            if ($permitResponse -eq "Y") {
                $skipBecauseOfPermit = $true
                Write-Host "Skipping login step and using offline permit." -ForegroundColor Green
            }
        } else {
            # Auto-skip in CI/CD if permit is found
            $skipBecauseOfPermit = $true
            Write-Host "Skipping login step and using offline permit (auto mode)." -ForegroundColor Green
        }
    }

    if (-not $skipBecauseOfPermit) {
        Write-Host "INFO:  Authorizing rgsubset, and starting a trial (if not already started):"
        Write-Host "CMD:    rgsubset auth login --i-agree-to-the-eula --start-trial" -ForegroundColor Blue
        & rgsubset auth login --i-agree-to-the-eula --start-trial

        Write-Host ""
        Write-Host "INFO:  Authorizing rganonymize:"
        Write-Host "CMD:    rganonymize auth login --i-agree-to-the-eula" -ForegroundColor Blue
        & rganonymize auth login --i-agree-to-the-eula
    }
}

# Log current CLI versions
$rgsubsetVersion = rgsubset --version
$rganonymizeVersion = rganonymize --version

Write-Host ""
Write-Host "rgsubset version is: $rgsubsetVersion" -ForegroundColor DarkCyan
Write-Host "rganonymize version is: $rganonymizeVersion" -ForegroundColor DarkCyan
Write-Host ""

###################################################################################################
# OBSERVATION / VALIDATION POINT – BEFORE SUBSETTING
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 4a: Validate Databases" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

Write-Host "Observe:" -ForegroundColor DarkCyan
Write-Host "There should now be two databases on the $($config.sqlInstance) server: $($config.sourceDb) and $($config.targetDb)" -ForegroundColor DarkCyan
Write-Host "$($config.sourceDb) should contain some data" -ForegroundColor DarkCyan 
if ($backupPath){
    Write-Host "$($config.targetDb) should be identical. In an ideal world, it would be schema identical, but empty of data." -ForegroundColor DarkCyan
}
else {
    Write-Host "$($config.targetDb) should have an identical schema, but no data" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "Copy and run the below SQL in blue to validate the '$($config.sourceDb)' and '$($config.targetDb)' databases:" -ForegroundColor DarkCyan
    Write-Host "  USE $($config.sourceDb)" -ForegroundColor Blue  -BackgroundColor Black 
    Write-Host "  --USE $($config.targetDb) -- Uncomment to run on target" -ForegroundColor Blue  -BackgroundColor Black 
    Write-Host "  SELECT COUNT (*) AS TotalOrders FROM Sales.Orders;" -ForegroundColor Blue  -BackgroundColor Black  
    Write-Host "  SELECT TOP 20 o.OrderID, o.CustomerID, o.ShipAddress AS 'o.ShipAddress', o.ShipCity AS 'o.ShipCity', c.Address AS 'c.Address', c.City AS 'c.City', c.ContactName AS 'c.ContactName'" -ForegroundColor Blue  -BackgroundColor Black 
    Write-Host "  FROM Sales.Customers c JOIN Sales.Orders o ON o.CustomerID = c.CustomerID" -ForegroundColor Blue  -BackgroundColor Black
    Write-Host "  ORDER BY o.OrderID ASC;" -ForegroundColor Blue  -BackgroundColor Black  
}

Prompt-ToContinue "> Databases validated? (Y/N)"

###################################################################################################
# STEP 4b: SUBSET DATA
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 4: Subset data using rgsubset" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

if (Prompt-ToContinue "> Proceed with subsetting using rgsubset? (Y/N)") {
    try {
        & "$PSScriptRoot/Steps/04_Subset-Data.ps1"; if ($LASTEXITCODE -ne 0) { throw "rgsubset failed with exit code $LASTEXITCODE" }
    } catch {
        Write-Error "Subsetting failed: $_"
        if (-not [System.Convert]::ToBoolean($env:autoContinue)) {
            try { Write-Host "> Press any key to exit..." -ForegroundColor Yellow; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
            catch { Write-Host "> Press Enter to exit..." -ForegroundColor Yellow; Read-Host }
        }
        exit 1
    }
}

###################################################################################################
# STEP 5: CLASSIFY DATA
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 5: Classify data in target DB for sensitive columns" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

if (Prompt-ToContinue "> Proceed with classification using rganonymize? (Y/N)") {
    try {
        & "$PSScriptRoot/Steps/05_Classify-Data.ps1"; if ($LASTEXITCODE -ne 0) { throw "Classification failed with exit code $LASTEXITCODE" }
    } catch {
        Write-Error "Classification failed: $_"
        if (-not [System.Convert]::ToBoolean($env:autoContinue)) {
            try { Write-Host "> Press any key to exit..." -ForegroundColor Yellow; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
            catch { Write-Host "> Press Enter to exit..." -ForegroundColor Yellow; Read-Host }
        }
        exit 1
    }
}

###################################################################################################
# STEP 6: MAP CLASSIFIED COLUMNS TO MASKING PLAN
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 6: Map classification to a masking.json" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

if (Prompt-ToContinue "> Proceed with mapping using rganonymize? (Y/N)") {
    try {
        & "$PSScriptRoot/Steps/06_Map-Data.ps1"; if ($LASTEXITCODE -ne 0) { throw "Mapping failed with exit code $LASTEXITCODE" }
    } catch {
        Write-Error "Mapping failed: $_"
        if (-not [System.Convert]::ToBoolean($env:autoContinue)) {
            try { Write-Host "> Press any key to exit..." -ForegroundColor Yellow; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
            catch { Write-Host "> Press Enter to exit..." -ForegroundColor Yellow; Read-Host }
        }
        exit 1
    }
}


###################################################################################################
# STEP 7: APPLY MASKING TO TARGET DB
###################################################################################################
Write-Host "=============================================================================================" -ForegroundColor Blue
Write-Host "STEP 7: Apply masking using masking.json" -ForegroundColor Cyan
Write-Host "=============================================================================================" -ForegroundColor Blue

if (Prompt-ToContinue "> Proceed with masking using rganonymize? (Y/N)") {
    try {
        & "$PSScriptRoot/Steps/07_Mask-Data.ps1"; if ($LASTEXITCODE -ne 0) { throw "Masking failed with exit code $LASTEXITCODE" }
    } catch {
        Write-Error "Masking failed: $_"
        if (-not [System.Convert]::ToBoolean($env:autoContinue)) {
            try { Write-Host "> Press any key to exit..." -ForegroundColor Yellow; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
            catch { Write-Host "> Press Enter to exit..." -ForegroundColor Yellow; Read-Host }
        }
        exit 1
    }
}


###################################################################################################
# DONE!
###################################################################################################

Write-Host "Congratulations! All steps completed!" -ForegroundColor Green
Write-Host "Next:" -ForegroundColor DarkCyan
Write-Host "- Review rgsubset-options.json examples in ./Setup_Files" -ForegroundColor DarkCyan
Write-Host "- Visit Redgate TDM docs for deeper customizations:" -ForegroundColor DarkCyan
Write-Host "  https://documentation.red-gate.com/testdatamanager/command-line-interface-cli" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "Want help? Contact Redgate or email sales@red-gate.com" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "**************************************   FINISHED!   **************************************" -ForegroundColor Green

if (-not [System.Convert]::ToBoolean($env:autoContinue)) {
    try { Write-Host "> Press any key to exit..." -ForegroundColor Yellow; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
    catch { Write-Host "> Press Enter to exit..." -ForegroundColor Yellow; Read-Host }
}

