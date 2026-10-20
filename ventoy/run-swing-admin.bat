@echo off
REM ==============================================================================
REM shopsphere - Windows 11 Desktop Swing Admin Launcher
REM ==============================================================================
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo ==================================================================
echo   Starting shopsphere Desktop Swing Admin Application (Windows 11)
echo ==================================================================
echo   Admin Credentials:
echo     - Email:    pooja@shopsphere.com
echo     - Password: Pooja@123
echo ==================================================================
echo.

call mvn exec:java -Dexec.mainClass="com.shopsphere.swing.MainSwingAdmin" -pl shopsphere-swing-admin

if errorlevel 1 (
    echo.
    echo [ERROR] Swing Application exited with an error.
    pause
)

