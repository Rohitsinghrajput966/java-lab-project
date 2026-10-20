@echo off
REM ==============================================================================
REM shopsphere - Windows 11 Java Socket Network Test (java.net Port 9090)
REM ==============================================================================
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo ==================================================================
echo   Starting shopsphere java.net Inventory Server on Port 9090...
echo ==================================================================

REM Start server in a separate background window
start "shopsphere Network Server" /MIN cmd /c "mvn exec:java -Dexec.mainClass=\"com.shopsphere.network.server.InventoryServer\" -pl shopsphere-network"

echo Waiting 3 seconds for server to initialize...
timeout /t 3 /nobreak >nul

echo.
echo Running java.net Inventory Client against localhost:9090...
echo ------------------------------------------------------------------
call mvn exec:java -Dexec.mainClass="com.shopsphere.network.client.InventoryClient" -pl shopsphere-network

echo.
echo Stopping Inventory Server...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :9090 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ==================================================================
echo   java.net Socket Server & Client test completed!
echo ==================================================================
pause

