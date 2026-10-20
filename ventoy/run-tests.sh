#!/usr/bin/env bash
# ==============================================================================
# shopsphere - Run Complete Automated Integration Test Suite
# ==============================================================================
set -e

BASE_URL="http://localhost:8080"
COOKIE_JAR="/tmp/cookie_customer.txt"
ADMIN_COOKIE="/tmp/cookie_admin.txt"
rm -f "$COOKIE_JAR" "$ADMIN_COOKIE"

if ! curl -s -I "$BASE_URL/" > /dev/null 2>&1; then
    echo "Tomcat server is not running at $BASE_URL."
    echo "Starting it now via ./run-web.sh..."
    "$(dirname "$0")/run-web.sh"
fi

echo "=================================================================="
echo "  Running shopsphere End-to-End Integration Tests"
echo "  Target URL: $BASE_URL"
echo "=================================================================="

echo ""
echo "--- 1. Testing Storefront & Product Catalog ---"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/")
echo "GET / -> HTTP $STATUS"
test "$STATUS" = "200"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/product-details?id=1")
echo "GET /product-details?id=1 -> HTTP $STATUS"
test "$STATUS" = "200"

echo ""
echo "--- 2. Testing Customer Authentication ---"
LOGIN_STATUS=$(curl -s -c "$COOKIE_JAR" -b "$COOKIE_JAR" -d "email=priya@shopsphere.com&password=Priya@123" -X POST "$BASE_URL/login" -o /dev/null -w "%{http_code}")
echo "POST /login (Customer - Priya) -> HTTP $LOGIN_STATUS"
test "$LOGIN_STATUS" = "302"

PROFILE_STATUS=$(curl -s -b "$COOKIE_JAR" -o /dev/null -w "%{http_code}" "$BASE_URL/profile")
echo "GET /profile (with session) -> HTTP $PROFILE_STATUS"
test "$PROFILE_STATUS" = "200"

echo ""
echo "--- 3. Testing Shopping Cart Flow ---"
CART_ADD=$(curl -s -b "$COOKIE_JAR" -c "$COOKIE_JAR" -d "action=add&productId=1&quantity=1" -X POST "$BASE_URL/cart" -o /dev/null -w "%{http_code}")
echo "POST /cart (add productId=1) -> HTTP $CART_ADD"

CART_PAGE=$(curl -s -b "$COOKIE_JAR" "$BASE_URL/cart")
if echo "$CART_PAGE" | grep -q -i -E "iPhone|Anarkali"; then
    echo "✓ Product verified in Cart HTML"
else
    echo "✗ Product not found in cart HTML"
    exit 1
fi

echo ""
echo "--- 4. Testing Admin Portal & Role-Based Access Control ---"
# Unauthorized access check
UNAUTH_ADMIN=$(curl -s -b "$COOKIE_JAR" -o /dev/null -w "%{http_code}" "$BASE_URL/admin/dashboard")
echo "GET /admin/dashboard (as customer) -> HTTP $UNAUTH_ADMIN (403 expected)"
test "$UNAUTH_ADMIN" = "403"

# Admin login
ADMIN_LOGIN=$(curl -s -c "$ADMIN_COOKIE" -b "$ADMIN_COOKIE" -d "email=pooja@shopsphere.com&password=Pooja@123" -X POST "$BASE_URL/login" -o /dev/null -w "%{http_code}")
echo "POST /login (Admin - Pooja) -> HTTP $ADMIN_LOGIN"
test "$ADMIN_LOGIN" = "302"

ADMIN_DASHBOARD=$(curl -s -b "$ADMIN_COOKIE" "$BASE_URL/admin/dashboard")
if echo "$ADMIN_DASHBOARD" | grep -q "Executive Dashboard"; then
    echo "✓ Executive Dashboard rendered successfully"
else
    echo "✗ Admin dashboard not rendered"
    exit 1
fi

ADMIN_PRODUCTS=$(curl -s -b "$ADMIN_COOKIE" -o /dev/null -w "%{http_code}" "$BASE_URL/admin/products")
echo "GET /admin/products -> HTTP $ADMIN_PRODUCTS"
test "$ADMIN_PRODUCTS" = "200"

ADMIN_ORDERS=$(curl -s -b "$ADMIN_COOKIE" -o /dev/null -w "%{http_code}" "$BASE_URL/admin/orders")
echo "GET /admin/orders -> HTTP $ADMIN_ORDERS"
test "$ADMIN_ORDERS" = "200"

echo ""
echo "--- 5. Testing RTU Syllabus Compliance Demos ---"
JSP_DEMO=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/syllabus/traditional-jsp")
echo "GET /syllabus/traditional-jsp -> HTTP $JSP_DEMO"
test "$JSP_DEMO" = "200"

I18N_PAGE=$(curl -s "$BASE_URL/syllabus/i18n?lang=hi")
if echo "$I18N_PAGE" | grep -q "उत्पाद सूची"; then
    echo "✓ Hindi i18n ResourceBundle verified"
else
    echo "✗ Hindi translation missing"
    exit 1
fi

XML_DEMO=$(curl -s "$BASE_URL/syllabus/jstl-xml")
if echo "$XML_DEMO" | grep -q "JSTL XML Tag Library Demonstration"; then
    echo "✓ JSTL XML transformation verified"
else
    echo "✗ JSTL XML demo missing"
    exit 1
fi

SQL_DEMO=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/syllabus/jstl-sql")
echo "GET /syllabus/jstl-sql -> HTTP $SQL_DEMO"
test "$SQL_DEMO" = "200"

echo ""
echo "=================================================================="
echo "  🎉 ALL INTEGRATION TESTS PASSED SUCCESSFULLY!"
echo "=================================================================="

