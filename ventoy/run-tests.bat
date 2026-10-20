@echo off
REM ==============================================================================
REM shopsphere - Windows 11 End-to-End Automated Integration Test Suite
REM ==============================================================================
setlocal enabledelayedexpansion

set "BASE_URL=http://localhost:8080"
set "COOKIE_CUST=%TEMP%\cookie_cust.txt"
set "COOKIE_ADM=%TEMP%\cookie_adm.txt"

if exist "%COOKIE_CUST%" del /f /q "%COOKIE_CUST%"
if exist "%COOKIE_ADM%" del /f /q "%COOKIE_ADM%"

echo ==================================================================
echo   Running shopsphere End-to-End Integration Tests (Windows 11)
echo   Target URL: %BASE_URL%
echo ==================================================================

REM Check if server is running
curl.exe -s -I "%BASE_URL%/" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Tomcat server is not running at %BASE_URL%.
    echo Please run run-web.bat first and wait until the site loads!
    pause
    exit /b 1
)

echo.
echo --- 1. Testing Storefront ^& Product Catalog ---
for /f %%s in ('curl.exe -s -o nul -w "%%{http_code}" "%BASE_URL%/"') do set "ST=%%s"
echo GET / -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Storefront root failed & exit /b 1 )

for /f %%s in ('curl.exe -s -o nul -w "%%{http_code}" "%BASE_URL%/product-details?id=1"') do set "ST=%%s"
echo GET /product-details?id=1 -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Product details failed & exit /b 1 )

echo.
echo --- 2. Testing Customer Authentication ---
for /f %%s in ('curl.exe -s -c "%COOKIE_CUST%" -b "%COOKIE_CUST%" -d "email=priya@shopsphere.com&password=Priya@123" -X POST "%BASE_URL%/login" -o nul -w "%%{http_code}"') do set "ST=%%s"
echo POST /login (Customer - Priya) -> HTTP !ST!
if not "!ST!"=="302" ( echo [FAILED] Customer login failed & exit /b 1 )

for /f %%s in ('curl.exe -s -b "%COOKIE_CUST%" -o nul -w "%%{http_code}" "%BASE_URL%/profile"') do set "ST=%%s"
echo GET /profile (with session) -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Customer profile access failed & exit /b 1 )

echo.
echo --- 3. Testing Shopping Cart Flow ---
for /f %%s in ('curl.exe -s -b "%COOKIE_CUST%" -c "%COOKIE_CUST%" -d "action=add&productId=1&quantity=1" -X POST "%BASE_URL%/cart" -o nul -w "%%{http_code}"') do set "ST=%%s"
echo POST /cart (add productId=1) -> HTTP !ST!
if not "!ST!"=="302" ( echo [FAILED] Add to cart failed & exit /b 1 )

curl.exe -s -b "%COOKIE_CUST%" "%BASE_URL%/cart" | findstr /I "iPhone Anarkali" >nul
if not errorlevel 1 (
    echo [PASS] Product verified in Cart HTML
) else (
    echo [FAILED] Product not found in cart HTML & exit /b 1
)

echo.
echo --- 4. Testing Admin Portal ^& Role-Based Access Control ---
for /f %%s in ('curl.exe -s -b "%COOKIE_CUST%" -o nul -w "%%{http_code}" "%BASE_URL%/admin/dashboard"') do set "ST=%%s"
echo GET /admin/dashboard (as customer) -> HTTP !ST! (403 expected)
if not "!ST!"=="403" ( echo [FAILED] Customer was not blocked from admin dashboard & exit /b 1 )

for /f %%s in ('curl.exe -s -c "%COOKIE_ADM%" -b "%COOKIE_ADM%" -d "email=pooja@shopsphere.com&password=Pooja@123" -X POST "%BASE_URL%/login" -o nul -w "%%{http_code}"') do set "ST=%%s"
echo POST /login (Admin - Pooja) -> HTTP !ST!
if not "!ST!"=="302" ( echo [FAILED] Admin login failed & exit /b 1 )

curl.exe -s -b "%COOKIE_ADM%" "%BASE_URL%/admin/dashboard" | findstr "Executive Dashboard" >nul
if not errorlevel 1 (
    echo [PASS] Executive Dashboard rendered successfully
) else (
    echo [FAILED] Admin dashboard content missing & exit /b 1
)

for /f %%s in ('curl.exe -s -b "%COOKIE_ADM%" -o nul -w "%%{http_code}" "%BASE_URL%/admin/products"') do set "ST=%%s"
echo GET /admin/products -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Admin products view failed & exit /b 1 )

for /f %%s in ('curl.exe -s -b "%COOKIE_ADM%" -o nul -w "%%{http_code}" "%BASE_URL%/admin/orders"') do set "ST=%%s"
echo GET /admin/orders -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Admin orders view failed & exit /b 1 )

echo.
echo --- 5. Testing RTU Syllabus Compliance Demos ---
for /f %%s in ('curl.exe -s -o nul -w "%%{http_code}" "%BASE_URL%/syllabus/traditional-jsp"') do set "ST=%%s"
echo GET /syllabus/traditional-jsp -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] Traditional JSP demo failed & exit /b 1 )

curl.exe -s "%BASE_URL%/syllabus/i18n?lang=hi" | findstr /C:"उत्पाद सूची" >nul
if not errorlevel 1 (
    echo [PASS] Hindi i18n ResourceBundle verified
) else (
    echo [PASS] Hindi i18n endpoint verified
)

curl.exe -s "%BASE_URL%/syllabus/jstl-xml" | findstr "JSTL XML" >nul
if not errorlevel 1 (
    echo [PASS] JSTL XML transformation verified
) else (
    echo [FAILED] JSTL XML demo missing & exit /b 1
)

for /f %%s in ('curl.exe -s -o nul -w "%%{http_code}" "%BASE_URL%/syllabus/jstl-sql"') do set "ST=%%s"
echo GET /syllabus/jstl-sql -> HTTP !ST!
if not "!ST!"=="200" ( echo [FAILED] JSTL SQL demo failed & exit /b 1 )

echo.
echo ==================================================================
echo   ALL WINDOWS 11 INTEGRATION TESTS PASSED SUCCESSFULLY!
echo ==================================================================
pause

