@echo off
REM ==============================================================================
REM shopsphere - Windows 11 Stop Web Application (Apache Tomcat 10.1)
REM ==============================================================================
setlocal enabledelayedexpansion

echo ==================================================================
echo   Stopping shopsphere Web Server...
echo ==================================================================

if defined CATALINA_HOME (
    if exist "%CATALINA_HOME%\bin\shutdown.bat" (
        echo Invoking Tomcat shutdown script...
        call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
    )
)

REM Kill process on port 8080 if still running
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do (
    echo Stopping process PID %%a on port 8080...
    taskkill /F /PID %%a >nul 2>&1
)

echo shopsphere Web Server stopped.
timeout /t 2 /nobreak >nul

