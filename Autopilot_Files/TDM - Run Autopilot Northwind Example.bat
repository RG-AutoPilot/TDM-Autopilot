@echo off
:: Check if the script is running as an administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b
)

:: Get the directory where the batch file is located and set parent folder
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%\..") do set "PARENT_DIR=%%~fI"

:: Set the working directory dynamically and run PowerShell as administrator
powershell -NoProfile -NoExit -Command "& {Start-Process PowerShell -ArgumentList \"-NoProfile -NoExit -ExecutionPolicy Bypass -Command `\"Set-Location -Path '%PARENT_DIR%'; & .\run-tdm-autopilot.ps1 -skipAuth`\"\" -Verb RunAs}"
