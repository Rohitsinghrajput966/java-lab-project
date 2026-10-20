@echo off
REM ==============================================================================
REM shopsphere - Windows 11 Java RMI Remote Object Test (Port 1099)
REM ==============================================================================
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo ==================================================================
echo   Starting shopsphere Java RMI Server & Registry on Port 1099...
echo ==================================================================

REM Start RMI server in separate background window
start "shopsphere RMI Server" /MIN cmd /c "mvn exec:java -Dexec.mainClass=\"com.shopsphere.rmi.server.RmiServerLauncher\" -pl shopsphere-rmi"

echo Waiting 3 seconds for RMI registry to initialize...
timeout /t 3 /nobreak >nul

echo.
echo Running Java RMI Client Test against localhost:1099...
echo ------------------------------------------------------------------
call mvn exec:java -Dexec.mainClass="com.shopsphere.rmi.client.RmiClientTest" -pl shopsphere-rmi

echo.
echo Stopping RMI Server...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :1099 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ==================================================================
echo   Java RMI Remote Service test completed!
echo ==================================================================
pause

