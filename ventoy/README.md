# shopsphere - Women & Girls Fashion E-Commerce Platform


A modern, production-grade Java Enterprise E-Commerce application built on **Jakarta EE 10**, modern MVC architectural patterns, high-concurrency database connection pooling, distributed network microservices, and containerized deployment pipelines — styled with a vibrant, Flipkart-inspired Women's & Girls' Fashion boutique storefront.

---

## 🌟 What's New in shopsphere

### 1. Modern UI & Flipkart-Inspired Visual Overhaul
- **Brand Identity & Fashion Logo:** Custom rose & fuchsia boutique emblem with vector SVG variations (`shopsphere-logo.svg`, `shopsphere-logo-light.svg`) designed for light and dark viewports, featuring chic typography and heart motif.
- **Flipkart-Style Header & Navigation:** Clean horizontal layout with brand logo on the left, central quick-search bar with category filters, and positioned icons for Catalog, User Profile, Wishlist, and Cart featuring a custom boutique shopping tote logo (`cart-logo.svg`).
- **Flipkart-Inspired Fashion Hero Banner:** Full-width visual banner (`hero-fashion-banner.jpg`) showcasing festival & partywear girl fashion, quick category navigation pills (Ethnic Wear, Western Wear, Co-ord Sets, Lehengas, Handbags & Jhumkas), and direct CTA links.
- **Girl-Centric Fashion Catalog:** 100% women's and girls' fashion products (Anarkali kurta sets, Banarasi silk sarees, floral tiered maxi dresses, sequin embroidered lehengas, Chikankari kurtis, jhumkas, and quilted handbags). Electronic gadgets and headphones have been completely removed from the front page and catalog.
- **Streamlined Storefront Layout:**
  - Removed top offers headline bar and flash sale timers for an elegant, premium boutique feel.
  - Eliminated bulky 12-department grids, replaced with a clean, high-performance "Catalog" browse view with instant price range filters and sorting.
  - Redesigned product cards with floating wishlist heart buttons, instant "Add to Cart" triggers, and rating badges.
  - Authentic Hindi testimonials and social proof showcase.

---

### 2. Upgraded Admin Panel & Management Features
The Admin Portal (`/admin/dashboard`) has been overhauled into an executive command center:

- **Executive Analytics & KPI Cards:** Live gross revenue, total completed orders, registered customer count, average order value (AOV), and inventory health tracking.
- **Interactive Visual Charts:** Integrated Chart.js charts displaying real-time Revenue Trends (line chart) and Category Sales Breakdown (doughnut chart).
- **Live Infrastructure Telemetry:** Real-time JVM heap memory metrics, server uptime timer, and HikariCP database connection pool diagnostics.
- **Product Catalog Management (`/admin/products`):**
  - Instant inline stock quantity updater (`/admin/products/stock`) without leaving the page.
  - One-click product visibility toggle (`/admin/products/toggle`) for instant activation/deactivation.
  - Advanced search filters by keyword, product category, and stock status (Low Stock, Out of Stock, In Stock).
  - Modal-based new product creation with image URL, pricing, and discount configuration.
- **Order Fulfillment Center (`/admin/orders`):**
  - Multi-criteria order search by Order ID, customer email, order status, or payment method.
  - Dual status updater allowing administrators to independently change order fulfillment (`PENDING`, `CONFIRMED`, `SHIPPED`, `DELIVERED`, `CANCELLED`) and payment settlement status (`PENDING`, `PAID`, `FAILED`, `REFUNDED`).
- **Category Management (`/admin/categories`):**
  - Full CRUD support for fashion categories (Ethnic, Western, Fusion, Handbags, Jewelry), including icon classes, descriptions, and active/inactive status toggling.
- **Promotional Coupon Engine (`/admin/coupons`):**
  - Search and filter vouchers by code, discount type (`PERCENTAGE` vs. `FLAT`), minimum order spend threshold, and expiry status.
- **Customer Account Management (`/admin/customers`):**
  - View registered customer activity, lifetime spend, and orders.
  - Instant RBAC role toggling (`CUSTOMER` <-> `ADMIN`).
  - One-click account suspension toggle (`ACTIVE` <-> `SUSPENDED`).

---

## 🏛️ Platform Architecture & Submodules

```
shopsphere/
├── shopsphere-common/          # Core Domain Entities (Product, Order, User, Category, Coupon), DTOs & BCrypt Utils
├── shopsphere-dao/             # JDBC DAOs, HikariCP Connection Pool & Unified Service Layer
├── shopsphere-web/             # Jakarta EE 10 Servlets, JSTL 3.0 JSPs, Filters, Listeners & Storefront
├── shopsphere-swing-admin/     # Standalone Desktop GUI (Swing) with Pluggable Look & Feel
├── shopsphere-network/         # Low-level TCP Socket Inventory Server & Client (java.net on port 9090)
├── shopsphere-rmi/             # Distributed Object Services (Java RMI Registry & Remote Services on port 1099)
├── database/               # MySQL 8.0+ / H2 Compatible Production Database DDL & Seed Data (shopsphere.sql)
└── docker/                 # Multi-Stage Dockerfile & Production Docker Compose Configuration
```

---

## 🛠️ Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Language & Platform** | Java 17 / 21 LTS |
| **Web Container** | Apache Tomcat 10.1+ (Jakarta EE 10 Servlet 6.0, JSP 3.1, JSTL 3.0) |
| **Database & Pooling** | HikariCP 5.1.0, MySQL 8.0 Connector / Embedded H2 2.2 (`AUTO_SERVER=TRUE`) |
| **Desktop Client** | Java Swing with Native System Look and Feel |
| **Networking & RPC** | `java.net` TCP Sockets (port 9090), Java RMI (port 1099) |
| **Security** | jBCrypt 0.4.0 (Blowfish salted hashing), Session Fixation Countermeasures, RBAC Filters |
| **Frontend Styling** | Bootstrap 5.3, Bootstrap Icons 1.11, Google Fonts (*Outfit*, *Plus Jakarta Sans*), Custom Fashion Palette |
| **Data Visualization** | Chart.js 4.4 |
| **DevOps & Containers** | Multi-Stage Docker, Docker Compose, Nginx Alpine, GitHub Actions CI/CD |

---

## ⚡ Quick Start & Execution

### Default Hindi Demo Credentials

| Role | Name | Email | Password | Access Area |
| :--- | :--- | :--- | :--- | :--- |
| **System Administrator** | Pooja Sharma | `pooja@shopsphere.com` | `Pooja@123` | Storefront & Executive Admin Portal (`/admin/dashboard`) |
| **Verified Customer** | Priya Patel | `priya@shopsphere.com` | `Priya@123` | Customer Storefront, Cart, Orders & Profile |
| **Customer** | Ananya Verma | `ananya@shopsphere.com` | `Ananya@123` | Customer Storefront & Orders |
| **Customer** | Rohit Kumar | `rohit@shopsphere.com` | `Rohit@123` | Customer Storefront & Orders |

*(Note: 1-Click "Demo Fill" buttons are available on the login page for instant authentication).*

---

### 1. Build Entire Platform
```bash
mvn clean package -DskipTests
```

### 2. Run Single-Command Helper Scripts

**For Linux / macOS:**
```bash
./run-web.sh            # Starts or deploys shopsphere on Apache Tomcat 10.1 (http://localhost:8080/)
./stop-web.sh           # Stops Tomcat cleanly
./run-tests.sh          # Runs the complete automated End-to-End Integration Test Suite
./run-network-test.sh   # Runs TCP Socket Server & Client test (port 9090)
./run-rmi-test.sh       # Runs Java RMI Remote Object test (port 1099)
./run-swing-admin.sh    # Launches the Desktop Java Swing Admin Client
```

**For Windows 11 (CMD / PowerShell):**
*(See [HOW_TO_RUN_WINDOWS_11.md](HOW_TO_RUN_WINDOWS_11.md) for complete installation & setup guide)*
```cmd
build.bat               # Compiles all 7 modules via Maven
run-web.bat             # Deploys WAR to Tomcat & opens http://localhost:8080/
stop-web.bat            # Stops Tomcat web server
run-swing-admin.bat     # Launches Desktop Swing Admin GUI
run-network-test.bat    # Tests TCP Socket Server & Client (port 9090)
run-rmi-test.bat        # Tests Java RMI Remote Object Services (port 1099)
run-tests.bat           # Runs End-to-End Test Suite in Command Prompt
.\run-tests.ps1         # Runs End-to-End Test Suite in PowerShell
```

---

## 🧪 Automated Integration Test Suite

Execute the comprehensive test suite verifying all layers:

```bash
./run-tests.sh
```

**Verified Test Scenarios:**
1. **Storefront & Catalog:** `GET /` and `GET /product-details?id=1` return `HTTP 200`.
2. **Customer Authentication:** `POST /login` with customer credentials (`priya@shopsphere.com`) authenticates and issues session (`HTTP 302` -> `GET /profile HTTP 200`).
3. **Shopping Cart Flow:** Adds line items (Anarkali Kurta Set), validates cart session state, recalculates discounts, and renders in cart HTML.
4. **Admin Portal & RBAC:**
   - Verifies unauthorized customer access to `/admin/dashboard` is blocked with `HTTP 403 Forbidden`.
   - Logs in as Administrator (`pooja@shopsphere.com`), loads `/admin/dashboard`, and confirms KPI widgets, charts, and telemetry.
   - Verifies `/admin/products` and `/admin/orders` management views return `HTTP 200`.
5. **Academic / RTU Syllabus Compliance Demos:**
   - Traditional JSP scriptlets (`/syllabus/traditional-jsp`) -> `HTTP 200`.
   - Multi-language i18n ResourceBundle (`/syllabus/i18n?lang=hi`) -> verified Hindi translation output.
   - JSTL XML transformation (`/syllabus/jstl-xml`) -> verified XML parsing and formatting.
   - JSTL SQL tags (`/syllabus/jstl-sql`) -> `HTTP 200`.

---

## 🐳 Production Docker & Container Deployment

Run the complete multi-tier containerized stack (MySQL 8.0 + Apache Tomcat 10.1 + Nginx reverse proxy):

```bash
cd docker
docker compose up -d --build
```

The stack exposes:
- **Port 80:** Nginx reverse proxy with gzip compression and security headers.
- **Port 8080:** Direct Apache Tomcat application container.
- **Port 3306:** Persistent MySQL database with automated schema initialization from `database/shopsphere.sql`.

---

## ☁️ Continuous Deployment to Azure Virtual Machine

The repository includes a production-ready GitHub Actions workflow (`.github/workflows/deploy.yml`):
1. **Continuous Integration:** Compiles all 7 modules with Eclipse Temurin JDK 21, runs tests, and archives `shopsphere-web.war`.
2. **Automated SSH Deployment:** Securely connects to the Azure Linux VM via SSH, checks out latest code, generates `.env` credentials, builds containers via Docker Compose, and polls the ingress health check (`http://localhost/`) with automated rollback on failure.

---

## 📄 License
Enterprise Commercial License &copy; 2026 shopsphere Inc. All rights reserved.

