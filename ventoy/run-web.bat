@echo off
REM ==============================================================================
REM shopsphere - Windows 11 Web Application Launcher (Apache Tomcat 10.1)
REM ==============================================================================
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo ==================================================================
echo   Starting ShopSphere Mega E-Commerce Platform (Windows 11)
echo ==================================================================

REM Check Java
if not defined JAVA_HOME (
    if exist "C:\Users\lenovo\.jdks\openjdk-26.0.2" set "JAVA_HOME=C:\Users\lenovo\.jdks\openjdk-26.0.2"
    where java >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Java was not found!
        echo Please install JDK 17, 21, or 26 and set JAVA_HOME.
        pause
        exit /b 1
    )
) else (
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

REM Locate Apache Tomcat
if not defined CATALINA_HOME (
    REM Check common locations
    if exist "C:\Users\lenovo\OneDrive\Desktop\JAVA\apache-tomcat-11.0.25" set "CATALINA_HOME=C:\Users\lenovo\OneDrive\Desktop\JAVA\apache-tomcat-11.0.25"
    if not defined CATALINA_HOME if exist "%SCRIPT_DIR%..\apache-tomcat-11.0.25" set "CATALINA_HOME=%SCRIPT_DIR%..\apache-tomcat-11.0.25"
    if not defined CATALINA_HOME if exist "C:\apache-tomcat-10.1.20" set "CATALINA_HOME=C:\apache-tomcat-10.1.20"
    if not defined CATALINA_HOME if exist "C:\apache-tomcat-10.1" set "CATALINA_HOME=C:\apache-tomcat-10.1"
    if not defined CATALINA_HOME if exist "C:\Program Files\Apache Software Foundation\Tomcat 10.1" set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
    if not defined CATALINA_HOME if exist "%USERPROFILE%\apache-tomcat-10.1.20" set "CATALINA_HOME=%USERPROFILE%\apache-tomcat-10.1.20"
    if not defined CATALINA_HOME if exist "%USERPROFILE%\tools\apache-tomcat-10.1.20" set "CATALINA_HOME=%USERPROFILE%\tools\apache-tomcat-10.1.20"
    if not defined CATALINA_HOME if exist "%SCRIPT_DIR%tomcat" set "CATALINA_HOME=%SCRIPT_DIR%tomcat"
)

if not defined CATALINA_HOME (
    echo [WARNING] CATALINA_HOME environment variable is not set.
    set /p "CATALINA_HOME=Please enter the path to your Apache Tomcat 10.1 folder (e.g. C:\apache-tomcat-10.1): "
)

if not exist "%CATALINA_HOME%\bin\startup.bat" (
    echo [ERROR] Invalid Tomcat directory: %CATALINA_HOME%
    echo Could not find %CATALINA_HOME%\bin\startup.bat
    pause
    exit /b 1
)

echo Using Apache Tomcat: %CATALINA_HOME%

REM Build WAR if not built
if not exist "%SCRIPT_DIR%shopsphere-web\target\shopsphere-web.war" (
    echo.
    echo WAR file not found. Building shopsphere-web with Maven...
    call mvn package -DskipTests -pl shopsphere-web -am
    if errorlevel 1 (
        echo [ERROR] Maven build failed!
        pause
        exit /b 1
    )
)

echo.
echo Deploying WAR to Tomcat ROOT...
if exist "%CATALINA_HOME%\webapps\ROOT" (
    rmdir /s /q "%CATALINA_HOME%\webapps\ROOT" >nul 2>&1
)
if exist "%CATALINA_HOME%\webapps\ROOT.war" (
    del /f /q "%CATALINA_HOME%\webapps\ROOT.war" >nul 2>&1
)

copy /y "%SCRIPT_DIR%shopsphere-web\target\shopsphere-web.war" "%CATALINA_HOME%\webapps\ROOT.war" >nul
echo Deploy complete!

echo.
echo Starting Apache Tomcat in a separate window...
start "ShopSphere Web Server (Tomcat 11)" cmd /c "call \"%CATALINA_HOME%\bin\startup.bat\""

echo.
echo Waiting 5 seconds for Tomcat to initialize...
timeout /t 5 /nobreak >nul

echo ==================================================================
echo   ShopSphere is LIVE at: http://localhost:8080/
echo ==================================================================
echo   Quick Demo Logins:
echo     - Admin Portal:   pooja@shopsphere.com  / Pooja@123
echo     - Customer Store: priya@shopsphere.com  / Priya@123
echo ==================================================================
echo.
echo Opening browser to http://localhost:8080/ ...
start http://localhost:8080/

pause

