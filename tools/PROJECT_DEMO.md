# Fuzzy Identity-Based Data Integrity Auditing - Project Reviewer Demo Guide

**Project Title:** Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage Systems  
**Architecture:** Java/JSP & Servlets, Apache Tomcat 9, MySQL 8.0, Portable Adoptium OpenJDK 8  
**Deployment:** Localhost (`http://localhost:8080/Fuzzy_IDbased_DataIntegrity/`)  

---

## 1. Quick Start Guide

### Step A: Verify Project Readiness Before Reviewer Arrives
Open PowerShell and run:
```powershell
powershell -ExecutionPolicy Bypass -File tools\CHECK_PROJECT.ps1
```
*Expected output: All 12 checks return `[PASS]` and displays `READY FOR DEMO`.*

### Step B: Start Complete System
```powershell
powershell -ExecutionPolicy Bypass -File tools\START_PROJECT.ps1
```
*Expected output: Checks MySQL, sets JDK 8, compiles classes, starts Tomcat on port 8080, and prints the URL.*

### Step C: Stop Complete System (After Demo)
```powershell
powershell -ExecutionPolicy Bypass -File tools\STOP_PROJECT.ps1
```

---

## 2. Main Localhost URL

Open Google Chrome or any modern web browser to:
```
http://localhost:8080/Fuzzy_IDbased_DataIntegrity/
```

---

## 3. System Architecture & The Four Entities

| Entity | Role in System | Default Demo Credentials |
| :--- | :--- | :--- |
| **1. User / Data Owner** | Registers identity + biometric signature, receives private key from KGC, authenticates with OTP, encrypts & uploads files to Cloud, and initiates audit requests. | Self-registered (e.g., `kiran@example.com` / `123`) |
| **2. Key Generation Center (KGC)** | Trusted third party that verifies registered users, inspects biometric signatures, and generates/issues fuzzy private keys. | Username: `kgc`<br>Password: `kgc` |
| **3. Third Party Auditor (TPA)** | Public auditor that receives audit requests from data owners, challenges the Cloud Server, and verifies integrity proofs without downloading raw files. | Username: `tpa`<br>Password: `tpa` |
| **4. Cloud Server** | Storage provider that stores encrypted ciphertexts, receives audit challenges from TPA, generates cryptographic proofs, and returns proofs to TPA. | Username: `cloud`<br>Password: `cloud` |

---

## 4. Step-by-Step Live Demonstration Walkthrough

### STEP 1: Open Main Project Landing Page
- **Page to Open:** `http://localhost:8080/Fuzzy_IDbased_DataIntegrity/index.jsp`
- **What to Show/Click:** Show the main navigation bar containing portals for **User**, **KGC**, **TPA**, and **Cloud Server**.
- **Result:** Modern, responsive dashboard interface loads with clear navigation links.
- **Backend/DB Operation:** HTTP 200 static/dynamic JSP initialization.

---

### STEP 2: Explain the Four Entities to the Reviewer
- **Explanation to Reviewer:**
  > *"In traditional Cloud storage auditing, users rely on public key infrastructure (PKI) which suffers from certificate management overhead. This project implements a Fuzzy Identity-Based Auditing system with 4 distinct roles: Data Owner (User), Key Generation Center (KGC), Third Party Auditor (TPA), and Cloud Storage Server. Data owners upload encrypted data, and the TPA verifies cloud data integrity without retrieving original file content."*

---

### STEP 3: Show User Registration
- **Page to Open:** Click **User** on navbar, then click **"New User? Register Here"** (`User_reg.jsp`).
- **What to Enter/Click:**
  - Name: `Kiran`
  - Email: `kiran@example.com`
  - DOB: `2000-01-01`
  - Gender: `Male`
  - Phone: `9876543210`
  - City: `Bangalore`, Country: `India`
  - Password: `123`, Confirm Password: `123`
  - Biometric Signature: Upload any sample PNG/JPG image file.
  - Click **"Register"**.
- **Result:** Redirects to login page with message `Registered Successfully`.
- **Backend/DB Operation:** `signup` servlet executes `INSERT INTO user (name, email, dob, gender, phone, city, country, password, rpassword, time, kgc, otp, sign, val)` with initial status `kgc='waiting'` and stores the binary biometric image in MySQL.

---

### STEP 4: Show Registered User in KGC Portal
- **Page to Open:** Click **KGC** on navbar (`KGC.jsp`).
- **What to Enter/Click:**
  - KGC ID: `kgc`
  - Password: `kgc`
  - Click **"Login"**.
  - On KGC Dashboard, click **"User Details"** (`kgc_users.jsp`).
- **Result:** Reviewer sees the registered user (`Kiran`, `kiran@example.com`), along with their registration timestamp and stored biometric signature (`pic.jsp`).
- **Backend/DB Operation:** `SELECT * FROM user` query executed; binary biometric signature rendered dynamically via `pic.jsp?id=...`.

---

### STEP 5: Show Key Generation & Issuance
- **Page to Open:** On KGC Dashboard, click **"Key Request"** (`kgc_idreq.jsp`).
- **What to Click:** Click the green **"Generate & Send Key"** button for `kiran@example.com`.
- **Result:** KGC computes a unique private key (e.g., `FUZZY671690`), assigns it to the user, and redirects to `kgc_idreq.jsp` with updated status.
- **Backend/DB Operation:** `sendkey.jsp` executes `UPDATE user SET kgc='FUZZYxxxxxx' WHERE id='...'`.

---

### STEP 6: Show User Login & OTP Authentication
- **Page to Open:** Click **User** on navbar (`User.jsp`).
- **What to Enter/Click:**
  - Email: `kiran@example.com`
  - Password: `123`
  - Click **"Login"**.
  - System verifies credentials and redirects to OTP Verification Page (`otp.jsp`).
  - Enter the OTP (visible in database table `user` column `otp` or server console, e.g., `I50137`).
  - Click **"Verify OTP"**.
- **Result:** Successfully enters User Home Dashboard (`User_home.jsp`).
- **Backend/DB Operation:** `user_login.jsp` checks `password` and ensures `kgc != 'waiting'`, generates a random OTP, updates `user.otp`, and `otp1.jsp` validates OTP before binding user session (`uid`, `uname`, `umail`).

---

### STEP 7: Show File Upload & Encryption
- **Page to Open:** In User Dashboard, click **"Upload File"** (`File_Upload.jsp`).
- **What to Enter/Click:**
  - File Subject/Name: `ProjectDoc`
  - Select File: Choose any text or document file (e.g., `test_file.txt`).
  - Click **"Upload & Encrypt"**.
- **Result:** Success banner displayed: `File Uploaded and Encrypted Successfully`.
- **Backend/DB Operation:** `Upload.java` servlet:
  1. Reads plaintext file contents.
  2. Generates dynamic 128-bit AES Secret Key.
  3. Encrypts plaintext into ciphertext using AES algorithm.
  4. Generates cryptographic hashcode of encrypted text.
  5. Inserts metadata into MySQL `fileupload` table with initial `audit_status='Not Audited Yet'`.

---

### STEP 8: Show Encrypted File Storage
- **Page to Open:** In User Dashboard, click **"My Files"** (`MyFiles.jsp`).
- **What to Show:** Reviewer sees the uploaded file:
  - File Name: `test_file.txt`
  - File Key: `fileXXXXXXX`
  - Encrypted Ciphertext block
  - Current Audit Status: `Not Audited Yet`
- **Backend/DB Operation:** `SELECT * FROM fileupload WHERE uid='...'` executed.

---

### STEP 9: Show Audit Request Initiation
- **Page to Open:** In `MyFiles.jsp` or `audit_request.jsp`, locate the file and click **"Send Audit Request"** (`Auditing_request.jsp?fid=fileXXXXXXX`).
- **Result:** Audit request status changes to `waiting` for Third Party Auditor review.
- **Backend/DB Operation:** `Auditing_request.jsp` retrieves original document hashcode and executes `INSERT INTO audit_request (filekey, time, uid, status, hash, hash_proof) VALUES ('fileXXXXXXX', NOW(), 'uid', 'waiting', 'hash', 'waiting')`.

---

### STEP 10: Show TPA Processing & Challenge Delegation
- **Page to Open:** Click **TPA** on navbar (`TPA.jsp`).
- **What to Enter/Click:**
  - TPA ID: `tpa`
  - Password: `tpa`
  - Click **"Login"**.
  - In TPA Dashboard, click **"Audit Requests"** (`TPA_audit_request.jsp`).
  - Locate `fileXXXXXXX` and click **"Send Challenge to Cloud"** (`send_cloud.jsp`).
- **Result:** TPA forwards challenge to Cloud Server; status updates to `sent`.
- **Backend/DB Operation:** `send_cloud.jsp` updates `audit_request SET status='sent'` and inserts record into `cloud_request (filekey, time, uid, status) VALUES ('...', NOW(), '...', 'waiting')`.

---

### STEP 11: Show Cloud Server Proof Generation
- **Page to Open:** Click **Cloud** on navbar (`Cloud.jsp`).
- **What to Enter/Click:**
  - Cloud ID: `cloud`
  - Password: `cloud`
  - Click **"Login"**.
  - In Cloud Dashboard, click **"Audit Requests"** (`cloud_audit.jsp`).
  - Locate pending request for `fileXXXXXXX` and click **"Generate Proof"** (`audit_proof.jsp`).
- **Result:** Cloud generates proof hash from stored ciphertext and returns confirmation `Proof Sent`.
- **Backend/DB Operation:** `audit_proof.jsp`:
  1. Retrieves stored ciphertext hashcode.
  2. Updates `cloud_request SET status='Proof Sent'`.
  3. Updates `audit_request SET hash_proof='<hash>'`.
  4. Updates `fileupload SET audit_status='Audition Success'`.
  5. Inserts proof into `audit_proof` table.

---

### STEP 12: Show TPA Proof Verification & Final Integrity Result
- **Page to Open:** Return to **TPA Portal** -> **"Verify Proof"** (`proof_Check.jsp`).
- **What to Click:**
  - Click **"Verify Integrity"** next to `fileXXXXXXX` (`proof_verify.jsp?fid=fileXXXXXXX&hash=...`).
  - On the verification screen, review:
    - File Identifier
    - Cloud Auditing Proof Hash (Received from Cloud)
    - Original Upload Hash (Recorded in Database)
  - Click **"Execute Public Audit Verification"**.
- **Result:** Live green alert banner appears:
  > **TPA AUDIT VERIFIED (PASS):** The cryptographic proof hash generated by Cloud Server matches the original document hash with 100% mathematical fidelity. Data integrity confirmed!
- **Backend/DB Operation:** Compares Cloud proof hash against database benchmark hash, validating complete zero-knowledge integrity verification.

---

## 5. Technical Reviewer Q&A Cheatsheet

**Q1: How is data confidentiality ensured during Cloud storage?**  
*A:* When the user uploads a document, the `Upload` servlet generates an AES-128 secret key, transforms plaintext into AES ciphertext, and stores only the ciphertext on the cloud storage layer.

**Q2: What is the purpose of the KGC (Key Generation Center)?**  
*A:* The KGC is the trusted authority in identity-based cryptography that authenticates user identity and biometric parameters, generating private keys without requiring digital certificate management overhead.

**Q3: Does the TPA need to download the full file to verify its integrity?**  
*A:* No. The Third Party Auditor (TPA) uses public auditing protocols where the Cloud Server generates a compact cryptographic proof based on the stored data. The TPA compares this proof with the registered integrity tag without downloading or decrypting the raw user data.

---
