@echo off
REM ==============================================================================
REM shopsphere - Windows 11 One-Click Build Script (Apache Maven)
REM ==============================================================================
setlocal enabledelayedexpansion

echo ==================================================================
echo   Building shopsphere E-Commerce Platform (All 7 Modules)
echo ==================================================================

REM Check for JAVA_HOME
if not defined JAVA_HOME (
    echo [WARNING] JAVA_HOME is not set in your environment variables.
    echo Trying to find java.exe in PATH...
    where java >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Java was not found! Please install JDK 17 or 21 and set JAVA_HOME.
        echo Refer to HOW_TO_RUN_WINDOWS_11.md for instructions.
        pause
        exit /b 1
    )
) else (
    echo Found JAVA_HOME: %JAVA_HOME%
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

REM Check for Maven
where mvn >nul 2>&1
if errorlevel 1 (
    if defined M2_HOME (
        set "PATH=%M2_HOME%\bin;%PATH%"
    ) else if defined MAVEN_HOME (
        set "PATH=%MAVEN_HOME%\bin;%PATH%"
    ) else (
        echo [ERROR] Apache Maven was not found in PATH or M2_HOME!
        echo Please install Apache Maven and add its bin folder to PATH.
        echo Refer to HOW_TO_RUN_WINDOWS_11.md for instructions.
        pause
        exit /b 1
    )
)

echo Compiling and packaging modules with Maven...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo.
    echo [ERROR] Maven build failed! Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ==================================================================
echo   [SUCCESS] shopsphere Platform successfully built!
echo   WAR location: shopsphere-web\target\shopsphere-web.war
echo ==================================================================
echo.
pause

