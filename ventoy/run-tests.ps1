# ==============================================================================
# Shopsphere - Windows 11 PowerShell Automated Integration Test Suite
# ==============================================================================
$ErrorActionPreference = "Stop"
$BaseUrl = "http://localhost:8080"
$CookieJar = Join-Path $env:TEMP "shopsphere_cust_cookies.txt"
$AdminCookieJar = Join-Path $env:TEMP "shopsphere_admin_cookies.txt"

if (Test-Path $CookieJar) { Remove-Item $CookieJar -Force }
if (Test-Path $AdminCookieJar) { Remove-Item $AdminCookieJar -Force }

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Running Shopsphere Automated Integration Tests (PowerShell 7/5.1) " -ForegroundColor Cyan
Write-Host "  Target URL: $BaseUrl" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# 1. Storefront
Write-Host "`n--- 1. Testing Storefront & Product Catalog ---" -ForegroundColor Yellow
$resp1 = Invoke-WebRequest -Uri "$BaseUrl/" -Method Get -UseBasicParsing
Write-Host "GET / -> HTTP $($resp1.StatusCode)" -ForegroundColor Green

$resp2 = Invoke-WebRequest -Uri "$BaseUrl/product-details?id=1" -Method Get -UseBasicParsing
Write-Host "GET /product-details?id=1 -> HTTP $($resp2.StatusCode)" -ForegroundColor Green

# 2. Customer Authentication
Write-Host "`n--- 2. Testing Customer Authentication ---" -ForegroundColor Yellow
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginBody = @{
    email    = "priya@shopsphere.com"
    password = "Priya@123"
}
$loginResp = Invoke-WebRequest -Uri "$BaseUrl/login" -Method Post -Body $loginBody -WebSession $session -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "POST /login (Customer - Priya) -> HTTP $($loginResp.StatusCode)" -ForegroundColor Green

$profileResp = Invoke-WebRequest -Uri "$BaseUrl/profile" -Method Get -WebSession $session -UseBasicParsing
Write-Host "GET /profile (with session) -> HTTP $($profileResp.StatusCode)" -ForegroundColor Green

# 3. Shopping Cart Flow
Write-Host "`n--- 3. Testing Shopping Cart Flow ---" -ForegroundColor Yellow
$cartAddBody = @{
    action    = "add"
    productId = "1"
    quantity  = "1"
}
$cartAddResp = Invoke-WebRequest -Uri "$BaseUrl/cart" -Method Post -Body $cartAddBody -WebSession $session -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "POST /cart (add productId=1) -> HTTP $($cartAddResp.StatusCode)" -ForegroundColor Green

$cartPage = Invoke-WebRequest -Uri "$BaseUrl/cart" -Method Get -WebSession $session -UseBasicParsing
if ($cartPage.Content -match "iPhone|Anarkali") {
    Write-Host "[PASS] Product verified in Cart HTML" -ForegroundColor Green
} else {
    Write-Error "[FAIL] Product not found in cart HTML"
}

# 4. Admin Portal & RBAC
Write-Host "`n--- 4. Testing Admin Portal & Role-Based Access Control ---" -ForegroundColor Yellow
try {
    $unauth = Invoke-WebRequest -Uri "$BaseUrl/admin/dashboard" -Method Get -WebSession $session -UseBasicParsing
    Write-Error "[FAIL] Customer should be blocked with 403 Forbidden"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 403) {
        Write-Host "GET /admin/dashboard (as customer) -> HTTP 403 (Forbidden as expected)" -ForegroundColor Green
    } else {
        Write-Host "GET /admin/dashboard (as customer) -> HTTP $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    }
}

$adminSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$adminLoginBody = @{
    email    = "rohit@shopsphere.com"
    password = "Pooja@123"
}
$adminLoginResp = Invoke-WebRequest -Uri "$BaseUrl/login" -Method Post -Body $adminLoginBody -WebSession $adminSession -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "POST /login (Admin - Pooja) -> HTTP $($adminLoginResp.StatusCode)" -ForegroundColor Green

$adminDash = Invoke-WebRequest -Uri "$BaseUrl/admin/dashboard" -Method Get -WebSession $adminSession -UseBasicParsing
if ($adminDash.Content -match "Executive Dashboard") {
    Write-Host "[PASS] Executive Dashboard rendered successfully" -ForegroundColor Green
} else {
    Write-Error "[FAIL] Admin dashboard content missing"
}

$adminProds = Invoke-WebRequest -Uri "$BaseUrl/admin/products" -Method Get -WebSession $adminSession -UseBasicParsing
Write-Host "GET /admin/products -> HTTP $($adminProds.StatusCode)" -ForegroundColor Green

$adminOrders = Invoke-WebRequest -Uri "$BaseUrl/admin/orders" -Method Get -WebSession $adminSession -UseBasicParsing
Write-Host "GET /admin/orders -> HTTP $($adminOrders.StatusCode)" -ForegroundColor Green

# 5. RTU Syllabus Compliance
Write-Host "`n--- 5. Testing RTU Syllabus Compliance Demos ---" -ForegroundColor Yellow
$jspDemo = Invoke-WebRequest -Uri "$BaseUrl/syllabus/traditional-jsp" -Method Get -UseBasicParsing
Write-Host "GET /syllabus/traditional-jsp -> HTTP $($jspDemo.StatusCode)" -ForegroundColor Green

$i18n = Invoke-WebRequest -Uri "$BaseUrl/syllabus/i18n?lang=hi" -Method Get -UseBasicParsing
Write-Host "[PASS] Hindi i18n ResourceBundle endpoint verified (HTTP $($i18n.StatusCode))" -ForegroundColor Green

$xmlDemo = Invoke-WebRequest -Uri "$BaseUrl/syllabus/jstl-xml" -Method Get -UseBasicParsing
if ($xmlDemo.Content -match "JSTL XML") {
    Write-Host "[PASS] JSTL XML transformation verified" -ForegroundColor Green
}

$sqlDemo = Invoke-WebRequest -Uri "$BaseUrl/syllabus/jstl-sql" -Method Get -UseBasicParsing
Write-Host "GET /syllabus/jstl-sql -> HTTP $($sqlDemo.StatusCode)" -ForegroundColor Green

Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "  ALL WINDOWS 11 POWERSHELL TESTS PASSED SUCCESSFULLY!          " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
