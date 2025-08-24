@echo off

:: Check for administrative permissions
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell Start-Process '%0' -Verb runAs
    exit /b
)

:: Commands to be executed with admin privileges
cd /d "%~dp0"
smpd.exe -install
hydra_service.exe -install
pause
