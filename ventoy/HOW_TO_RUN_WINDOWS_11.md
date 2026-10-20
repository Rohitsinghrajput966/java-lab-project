# shopsphere - Windows 11 Complete Installation, Setup & Execution Guide

A comprehensive, beginner-friendly guide to installing, configuring, building, and running the **shopsphere Women & Girls Fashion E-Commerce Platform** on **Windows 11 (64-bit)**.

---

## 📋 System Prerequisites

Ensure your Windows 11 PC has:
- **Operating System:** Windows 11 Home, Pro, or Enterprise (64-bit)
- **RAM:** 4 GB minimum (8 GB recommended)
- **Disk Space:** 1 GB free disk space
- **Administrative Privileges** for setting Environment Variables

---

## 🛠️ Step 1: Install Java Development Kit (JDK 17 or 21)

shopsphere requires **Java 17 LTS** or **Java 21 LTS**.

### Download & Install:
1. Download **Eclipse Temurin JDK 21 (LTS)** installer for Windows:
   - Official Link: [https://adoptium.net/temurin/releases/?version=21](https://adoptium.net/temurin/releases/?version=21)
   - Choose: **Windows x64 .msi installer**
2. Run the downloaded `.msi` installer.
3. During setup, **enable** the options:
   - ✅ *Set JAVA_HOME variable*
   - ✅ *Add to PATH*
4. Click **Next** and complete installation.

### Verify Java Installation:
Open **Command Prompt (`cmd`)** or **PowerShell** and run:
```cmd
java -version
```
*Expected Output:* `openjdk version "21.0.x"` or `java version "17.0.x"`.

---

## 🛠️ Step 2: Install Apache Maven (3.8+)

Maven compiles and packages the multi-module Java project.

### Download & Install:
1. Download Apache Maven binary zip:
   - Official Link: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
   - Choose: `apache-maven-3.9.x-bin.zip`
2. Extract the zip to: `C:\Program Files\Maven` (or `C:\apache-maven`).
3. Add Maven to Windows Environment Variables:
   - Press `Win + S`, type **env**, and select **Edit the system environment variables**.
   - Click **Environment Variables...** at the bottom right.
   - Under **System Variables**, click **New**:
     - Variable name: `M2_HOME`
     - Variable value: `C:\Program Files\Maven\apache-maven-3.9.x`
   - Under **System Variables**, select `Path` and click **Edit...**:
     - Click **New** and add: `%M2_HOME%\bin`
   - Click **OK** on all dialogs.

### Verify Maven:
Open a **new** Command Prompt and run:
```cmd
mvn -v
```
*Expected Output:* `Apache Maven 3.9.x`.

---

## 🛠️ Step 3: Install Apache Tomcat 10.1 (Jakarta EE 10)

shopsphere is built on **Jakarta EE 10 (Servlet 6.0)** which requires **Apache Tomcat 10.1+**.

### Download & Setup:
1. Download Apache Tomcat 10.1:
   - Official Link: [https://tomcat.apache.org/download-10.cgi](https://tomcat.apache.org/download-10.cgi)
   - Under *Core*, download: **64-bit Windows zip** (e.g., `apache-tomcat-10.1.x-windows-x64.zip`)
2. Extract to a convenient folder, for example: `C:\apache-tomcat-10.1` (or in your user tools folder).
3. Set `CATALINA_HOME` in Windows Environment Variables:
   - Open **Environment Variables** (as done in Step 2).
   - Under **System Variables**, click **New**:
     - Variable name: `CATALINA_HOME`
     - Variable value: `C:\apache-tomcat-10.1` (replace with your actual folder path)
   - Add to `Path`:
     - Edit `Path` and add: `%CATALINA_HOME%\bin`
   - Click **OK** to save.

---

## 🗄️ Step 4: Database Setup (Zero Setup Required!)

shopsphere includes an **Embedded H2 Database Engine** configured with HikariCP high-performance connection pooling.
- **No MySQL installation is necessary!**
- On initial startup, shopsphere automatically creates and seeds the database files at:
  ```
  C:\Users\<YourUsername>\.shopsphere\h2_shopsphere.mv.db
  ```
- All categories, 22 boutique women's fashion products, vouchers, and Hindi user credentials are auto-populated out-of-the-box.

*(Optional)* If you prefer using MySQL 8.0, import `database/shopsphere.sql` into MySQL and set environment variable `shopsphere_DB_TYPE=mysql`.

---

## 🚀 Step 5: Quick Run Scripts for Windows 11

The root folder includes automated Windows Batch scripts (`.bat`) designed specifically for Windows 11:

| Script | Purpose |
| :--- | :--- |
| **`build.bat`** | Builds all 7 Maven submodules and packages `shopsphere-web.war` |
| **`run-web.bat`** | Deploys WAR to Tomcat, starts server, and opens `http://localhost:8080/` |
| **`stop-web.bat`** | Stops Apache Tomcat server cleanly |
| **`run-swing-admin.bat`** | Launches the standalone Java Swing Desktop Admin application |
| **`run-network-test.bat`** | Runs low-level TCP Socket Server & Client demo on port 9090 |
| **`run-rmi-test.bat`** | Runs Java RMI Remote Object Services demo on port 1099 |
| **`run-tests.bat`** | Runs the complete automated End-to-End Integration Test Suite |
| **`run-tests.ps1`** | Native Windows 11 PowerShell test runner |

---

## 🌐 Running the Web Application on Windows 11

### Method A: One-Click Execution (Recommended)
1. Double-click **`build.bat`** (or open `cmd` in the project folder and type `build.bat`).
2. Once the build finishes, double-click **`run-web.bat`**.
3. Tomcat starts in a separate window, deploys the web application, and automatically opens your browser to:
   ```
   http://localhost:8080/
   ```

### Method B: Manual Command Line Execution
```cmd
cd C:\path\to\shopsphere
mvn clean package -DskipTests
copy shopsphere-web\target\shopsphere-web.war %CATALINA_HOME%\webapps\ROOT.war
%CATALINA_HOME%\bin\startup.bat
```

---

## 🔑 Default Hindi Demo Credentials

Click the 1-Click **"Demo Fill"** buttons on `/login` or enter manually:

| Role | Name | Email | Password | Access Area |
| :--- | :--- | :--- | :--- | :--- |
| **System Administrator** | Pooja Sharma | `pooja@shopsphere.com` | `Pooja@123` | Storefront & Executive Admin Portal (`/admin/dashboard`) |
| **Verified Customer** | Priya Patel | `priya@shopsphere.com` | `Priya@123` | Customer Storefront, Cart, Orders & Profile |
| **Customer** | Ananya Verma | `ananya@shopsphere.com` | `Ananya@123` | Customer Storefront, Wishlist & Orders |
| **Customer** | Rohit Kumar | `rohit@shopsphere.com` | `Rohit@123` | Customer Storefront & Orders |

---

## 🖥️ Running Other Submodules on Windows 11

### 1. Desktop Swing Admin Application
Double-click **`run-swing-admin.bat`** or run:
```cmd
run-swing-admin.bat
```
- Launches the native Windows GUI desktop administration client with login screen.
- Log in with `pooja@shopsphere.com` / `Pooja@123`.

### 2. TCP Socket Server & Client (`java.net` on Port 9090)
Double-click **`run-network-test.bat`** or run:
```cmd
run-network-test.bat
```
- Starts TCP inventory socket server on port 9090.
- Queries product catalog for *"Kurta"* and displays serialized/deserialized responses.

### 3. Java RMI Distributed Remote Object Services (Port 1099)
Double-click **`run-rmi-test.bat`** or run:
```cmd
run-rmi-test.bat
```
- Starts RMI Registry and binds remote service stub on port 1099.
- Executes remote inventory lookups and stock update RPC calls.

### 4. Automated Integration Tests
Double-click **`run-tests.bat`** or run in PowerShell:
```powershell
.\run-tests.ps1
```
- Validates Storefront HTTP 200, Priya login, shopping bag flow, Pooja admin portal access, and RTU syllabus demonstrations.

---

## 🛠️ Windows 11 Troubleshooting FAQ

### 1. "Port 8080 already in use"
If port 8080 is blocked by an earlier Tomcat process or another application:
1. Open Command Prompt as Administrator and run:
   ```cmd
   netstat -ano | findstr :8080
   ```
2. Note the PID (the number at the far right, e.g. `12345`).
3. Terminate it:
   ```cmd
   taskkill /F /PID 12345
   ```
4. Run `stop-web.bat` which also automates this.

### 2. "mvn is not recognized as an internal or external command"
- Ensure you added `%M2_HOME%\bin` to your System `Path`.
- Close and reopen all Command Prompt / PowerShell windows after changing environment variables.

### 3. "PowerShell script cannot be loaded because running scripts is disabled"
If `run-tests.ps1` gives an execution policy warning:
1. Open PowerShell and run:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\run-tests.ps1
   ```

### 4. Windows Defender Firewall Prompt
When starting Tomcat or socket servers, Windows Firewall may ask:
- *"Windows Defender Firewall has blocked some features of this app"*
- Select: **Private networks (such as my home or work network)** and click **Allow access**.

### 5. How to Reset the Database on Windows
To completely re-seed the fashion catalog from scratch:
1. Run `stop-web.bat`.
2. Delete the database files in your user home directory:
   ```cmd
   del /f /q %USERPROFILE%\.shopsphere\h2_shopsphere.*
   ```
3. Run `run-web.bat`. The database will automatically be recreated fresh.

---

## 📄 License & Credits
Enterprise Commercial License &copy; 2026 shopsphere Inc. All rights reserved.
Developed for Java 17/21 LTS, Jakarta EE 10, Apache Tomcat 10.1, and Windows 11.

