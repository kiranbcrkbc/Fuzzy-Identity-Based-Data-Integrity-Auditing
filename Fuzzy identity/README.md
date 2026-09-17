# Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage Systems

[![Java](https://img.shields.io/badge/Java-8-orange.svg)](https://openjdk.org/)
[![Tomcat](https://img.shields.io/badge/Tomcat-9.0.98-blue.svg)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![Status](https://img.shields.io/badge/Release-Verified%20100%25-brightgreen.svg)]()

> **Major Academic Project**  
> **Department of Computer Science & Engineering**  
> **R R Institute of Technology**

---

## 1. Project Overview & Motivation

In modern cloud computing environments, data owners store vast amounts of critical data on untrusted remote cloud servers. To ensure that outsourced data remains uncorrupted without requiring data owners to download the entire dataset, **Public Data Integrity Auditing** mechanisms are employed.

Traditional identity-based auditing schemes rely on rigid identity identifiers (e.g., exact email addresses or IP strings). If biometric identifiers (such as iris, fingerprint, or biometric signatures) are utilized, natural measurement noise prevents exact string matching. This project implements a **Fuzzy Identity-Based Data Integrity Auditing Scheme** that tolerates biometric variance within a predetermined error tolerance metric, enabling reliable remote data auditing through a **Third Party Auditor (TPA)** while preserving privacy and computational efficiency.

---

## 2. System Architecture & Entities

The system architecture consists of four distinct operational entities:

```
                  +-----------------------------------+
                  |  Key Generation Center (KGC)      |
                  |  - Issues Private Keys on ID      |
                  |  - Approves User Biometrics       |
                  +-----------------+-----------------+
                                    |
                                    v
+------------------+     (2) Upload Encrypted     +---------------------+
|   Data Owner     | ---------------------------> | Cloud Server (CSS)  |
|   (User Portal)  | < - - - - - - - - - - - - -  | - AES-128 Storage   |
+--------+---------+     (6) Verification Result  | - Computes Proofs   |
         |                                        +----------+----------+
         | (4) Request Audit                                 ^
         v                                                   | (5) Audit Challenge
+--------+---------------------------------------------------+----------+
|                 Third Party Auditor (TPA) Suite                       |
|                 - Deterministic Cryptographic Proof Validation        |
|                 - Zero-Knowledge Public Audit Verification            |
+-----------------------------------------------------------------------+
```

1. **Data Owner (User):** Registers biometric identifiers, receives private keys, uploads encrypted files with SHA/MD5 integrity tags, and initiates audit requests.
2. **Key Generation Center (KGC):** Verifies user identity credentials and generates cryptographic private keys.
3. **Cloud Storage Server (CSS):** Stores AES-128 ciphertext blocks and deterministically computes auditing proofs upon TPA challenge requests.
4. **Third Party Auditor (TPA):** Publicly audits the cloud server on behalf of the user by issuing challenges and verifying computed mathematical proofs against original uploaded signatures.

---

## 3. Technology Stack & Prerequisites

- **Language & Runtime:** Java 8 (OpenJDK 8 Temurin `8u442-b06`)
- **Web Application Container:** Apache Tomcat `9.0.98` (Servlet 4.0 / JSP 2.3)
- **Relational Database:** MySQL 8.0 (Database schema: `fuzzy`)
- **Cryptographic Algorithms:** AES-128 CBC/ECB encryption/decryption, SHA-256 / SHA-1 checksum hashing
- **Frontend Design System:** Custom Cyberpunk Glassmorphism UI (`cyber_theme.css`) with responsive CSS grids, CSS variables, and modern typography
- **Containerization:** Docker & Docker Compose (`tomcat:9-jdk8-openjdk` + `mysql:8.0`)

---

## 4. Default Demonstration Credentials

| Role | Portal URL | Username / Identifier | Password | Function |
| :--- | :--- | :--- | :--- | :--- |
| **Data Owner (User)** | `/User.jsp` | `kiran@example.com` | `123` | Upload files, request audits, view proofs |
| **KGC Admin** | `/KGC.jsp` | `kgc` | `kgc` | Approve users, issue private keys |
| **TPA Auditor** | `/TPA.jsp` | `TPA` | `TPA` | Issue challenges, verify cloud proofs |
| **Cloud Server** | `/Cloud.jsp` | `cloud` | `cloud` | Receive challenges, generate proofs |

---

## 5. Local Setup & Execution Guide (Windows)

### Step 1: Initialize the MySQL Database
Ensure MySQL Server 8.0 is running on port 3306. Initialize the database schema:
```powershell
# Using MySQL Command Line or PowerShell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "source Fuzzy identity/DATABASE/Fuzzy.sql;"
```

### Step 2: Set Up Portable Runtimes (One-Time Setup)
If JDK 8 and Tomcat 9 are not pre-downloaded, run:
```powershell
.\tools\setup_runtime.ps1
```

### Step 3: Build & Deploy Application
Compiles all Java source files with JDK 8 and packages the production WAR archive:
```powershell
.\tools\build_and_deploy.ps1
```

### Step 4: Start Services & Launch System
```powershell
.\tools\START_PROJECT.ps1
```
The application opens automatically at: **`http://localhost:8080/Fuzzy_IDbased_DataIntegrity/`**

### Step 5: Stop Services
```powershell
.\tools\STOP_PROJECT.ps1
```

---

## 6. Vercel Serverless Cloud Deployment (`.vercel.app`)

The repository includes a modern, Vercel-native full-stack serverless architecture in the root directory:
- **Serverless API Handlers (`api/`):** Node.js serverless functions handling authentication, AES-128 cryptographic operations, KGC private key generation, TPA auditing challenges, and deterministic cloud proof verification.
- **Frontend Presentation Layer (`public/`):** Responsive Cyberpunk Glassmorphism UI for all 4 operational entities (`index.html`, `user.html`, `kgc.html`, `tpa.html`, `cloud.html`).
- **Database Connectivity:** Supports managed MySQL databases via environment variables (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`), with an automated serverless persistent fallback engine when deployed directly without external DB configuration.

### One-Click Vercel Deployment Instructions:
1. Navigate to **[Vercel Dashboard &rarr; Add New Project](https://vercel.com/new)**.
2. Select your connected GitHub account (**`kiranbcrkbc`**) and import repository:
   **`kiranbcrkbc/Fuzzy-Identity-Based-Data-Integrity-Auditing`**
3. Keep default settings (Framework: *Other*, Root Directory: `./`).
4. *(Optional)* Add production MySQL credentials under **Environment Variables** (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`).
5. Click **Deploy** &mdash; Vercel builds and deploys the live application in under 30 seconds to:
   **`https://fuzzy-identity-based-data-integrity-auditing.vercel.app`**

### Running the Vercel Application Locally:
```bash
npm install
npm start
# Opens at: http://localhost:3000/
```

### Running Automated Vercel Pipeline Tests (20 Stages):
```powershell
powershell -File tools/test_vercel_full_pipeline.ps1
```

---

## 7. Docker Containerized Deployment

Deploy with a single command on any machine with Docker installed:
```bash
docker-compose up --build -d
```
- Access application: `http://localhost:8080/`
- Database: Automatically initialized via `./Fuzzy identity/DATABASE/Fuzzy.sql`

---

## 7. Verification & Automated Test Harness

The project includes an exhaustive automated regression suite covering all positive and negative test cases:

```powershell
# 1. Verify all 28 HTTP endpoints and portals
powershell -File tools/test_endpoints.ps1

# 2. Run complete 17-Phase End-to-End Business Pipeline & Tampering Test
powershell -File tools/test_full_workflow.ps1

# 3. Test Live Public HTTPS URL
powershell -File tools/test_live_public_url.ps1
```

### Test Suite Coverage Matrix (100% PASS):
1. **User Registration** with biometric signature attachment
2. **KGC Approval & Key Issuance**
3. **User Authentication & Session Management**
4. **Two-Factor OTP Challenge Verification**
5. **AES-128 File Upload** with hashcode metadata generation
6. **Audit Request Initiation**
7. **TPA Challenge Dispatch to Cloud**
8. **Cloud Proof Computation**
9. **Positive TPA Proof Verification** (Proof == Original Hash)
10. **Positive User Integrity Check**
11. **Negative Tampering Detection** (Deliberate DB corruption triggers integrity breach warning)
12. **Negative Authentication** (Invalid passwords rejected)
13. **Negative Approval Check** (Unapproved users blocked until KGC approval)
14. **Negative OTP Challenge** (Incorrect OTP rejected)
15. **Duplicate Registration Prevention** (Duplicate emails rejected)
16. **Special Character Filename Handling** (Quotes and apostrophes safely sanitized)
17. **AES-128 Cryptographic Round-Trip Test** (100% deterministic plaintext match)

---

## 8. Live Public Demonstration

For remote demonstrations or presenting to external devices (e.g., mobile phones, review committee laptops):
```powershell
.\tools\START_TUNNEL.ps1
```
This command exposes the local Tomcat container via an encrypted TLS/HTTPS tunnel (`localhost.run`), generating an accessible public URL.

---

## 9. Security & Code Hardening Enhancements

- **SQL Injection Elimination:** Replaced all raw SQL string concatenations with parameterized `PreparedStatement` instances across all servlets and JSP pages.
- **Resource Leak Prevention:** Added structured `try-catch-finally` blocks utilizing `SQLconnection.close(con, stmt, rs)` helper methods across all database interactions.
- **Null Safety:** Implemented defensive null checks on all session parameters, multi-part form fields, and BLOB streams.
- **Configurable Environment Variables:** Database credentials are configurable via `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASS`, with zero hardcoded production secrets.
- **Input Sanitization:** Multi-part file upload parsing safely extracts basename tokens, neutralizing directory traversal attacks (`../`).

---

## 10. Research & Prototype Notes

This application is an educational prototype demonstrating the operational protocol and workflow of Fuzzy Identity-Based Auditing as outlined in cloud security research literature. In this implementation:
- Biometric identity values are simulated via cryptographic hash derivation.
- Symmetric block encryption is performed using standard Java Cryptography Architecture (JCA) AES-128.
- For high-assurance production deployments, a formal Bilinear Pairing library (e.g., JPBC / Pairing-Based Cryptography) should be integrated to implement exact Lagrange polynomial interpolation over fuzzy identity attribute sets.
