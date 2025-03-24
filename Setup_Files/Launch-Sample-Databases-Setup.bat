@echo off
:: Check if the script is running as an administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo By default this process will download and install the relevant Redgate Software files.
    echo If you'd prefer to run without admin privileges, please install DBA-Tools/Redgate TDM CLIs
    echo Please re-run as administrator or run 'run-tdm-autopilot.ps1' directly without administrative permissions.
    pause
    exit /b
)

:: Get the directory where the batch file is located and set parent folder
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%\..") do set "PARENT_DIR=%%~fI"

:: Set the working directory dynamically and run PowerShell as administrator
powershell -NoProfile -NoExit -Command "& {Start-Process PowerShell -ArgumentList \"-NoProfile -NoExit -ExecutionPolicy Bypass -Command `\"Set-Location -Path '%PARENT_DIR%'; & .\run-tdm-autopilot.ps1 -skipAuth -sampleDatabase Autopilot`\"\" -Verb RunAs}"
