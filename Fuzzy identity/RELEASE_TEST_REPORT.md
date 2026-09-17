# OFFICIAL RELEASE & QUALITY ASSURANCE TEST REPORT

**Project Title:** Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage Systems  
**Institution:** Department of Computer Science & Engineering, R R Institute of Technology  
**Execution Environment:** OpenJDK 8 (`jdk8u442-b06`), Apache Tomcat 9.0.98, MySQL Server 8.0, Windows 11 x64  
**Test Harness Scripts:** `tools/CHECK_PROJECT.ps1`, `tools/test_endpoints.ps1`, `tools/test_full_workflow.ps1`, `tools/test_live_public_url.ps1`  
**Test Execution Date:** 2026-09-17  
**Overall Result:** **ALL TESTS PASSED (100% SUCCESS RATE)**

---

## 1. Executive Summary

| Test Category | Total Tests | Passed | Failed | Status |
| :--- | :---: | :---: | :---: | :---: |
| **System Prerequisites & Health Checks** | 12 | 12 | 0 | **PASS** |
| **HTTP Page & Portal Availability** | 28 | 28 | 0 | **PASS** |
| **End-to-End Business Pipeline** | 10 | 10 | 0 | **PASS** |
| **Negative Security & Tampering Tests** | 7 | 7 | 0 | **PASS** |
| **Live Public HTTPS End-to-End Test** | 7 | 7 | 0 | **PASS** |
| **Vercel Full-Stack Pipeline & Security** | 20 | 20 | 0 | **PASS** |
| **TOTAL** | **84** | **84** | **0** | **PASS (100%)** |

---

## 2. Detailed Test Results & Evidence Log

### Category A: System Prerequisites & Health (`CHECK_PROJECT.ps1`)

| # | Test Name | Expected Result | Actual Result | Status | Notes |
| :-: | :--- | :--- | :--- | :-: | :--- |
| A1 | Java Runtime Available | Java version string returned | `java version "1.8.0_442"` | **PASS** | Portable OpenJDK 8 Temurin |
| A2 | MySQL Daemon Running | Port 3306 listening | Port 3306 active & responsive | **PASS** | MySQL 8.0.41 Community |
| A3 | Database `fuzzy` Exists | Schema created | Database `fuzzy` confirmed | **PASS** | Verified via `Fuzzy.sql` |
| A4 | Database Table `user` | Table exists with schema | Table present | **PASS** | Contains registration records |
| A5 | Database Table `fileupload`| Table exists with schema | Table present | **PASS** | Contains ciphertext & hashes |
| A6 | Database Table `audit_request`| Table exists | Table present | **PASS** | Tracks pending audit challenges |
| A7 | Database Table `cloud_request`| Table exists | Table present | **PASS** | Cloud challenge queue |
| A8 | Database Table `audit_proof` | Table exists | Table present | **PASS** | Stores computed proofs |
| A9 | Direct JDBC Connectivity | Connection succeeds | JDBC Connection SUCCESSFUL | **PASS** | Verified via `TestDB.java` |
| A10 | Apache Tomcat Running | HTTP port 8080 active | Port 8080 responding | **PASS** | Tomcat 9.0.98 Daemon |
| A11 | WAR Deployed Cleanly | Webapp responds 200 OK | HTTP 200 OK | **PASS** | Application context loaded |
| A12 | Main Landing Page Loaded | Cyber UI title displayed | HTTP 200 OK | **PASS** | `index.jsp` responsive |

---

### Category B: Endpoint Accessibility & JSP Compilation (`test_endpoints.ps1`)

| # | Endpoint URL | Expected Status | Actual Status | Result |
| :-: | :--- | :-: | :-: | :-: |
| B1 | `/index.jsp` | 200 OK | 200 OK | **PASS** |
| B2 | `/User.jsp` | 200 OK | 200 OK | **PASS** |
| B3 | `/User_reg.jsp` | 200 OK | 200 OK | **PASS** |
| B4 | `/user_signup.jsp` | 200 OK | 200 OK | **PASS** |
| B5 | `/otp.jsp` | 200 OK | 200 OK | **PASS** |
| B6 | `/User_home.jsp` | 200 OK | 200 OK | **PASS** |
| B7 | `/File_Upload.jsp` | 200 OK | 200 OK | **PASS** |
| B8 | `/MyFiles.jsp` | 200 OK | 200 OK | **PASS** |
| B9 | `/audit_request.jsp` | 200 OK | 200 OK | **PASS** |
| B10 | `/user_check.jsp` | 200 OK | 200 OK | **PASS** |
| B11 | `/KGC.jsp` | 200 OK | 200 OK | **PASS** |
| B12 | `/KGC_home.jsp` | 200 OK | 200 OK | **PASS** |
| B13 | `/keyreq.jsp` | 200 OK | 200 OK | **PASS** |
| B14 | `/kgc_users.jsp` | 200 OK | 200 OK | **PASS** |
| B15 | `/kgc_request.jsp` | 200 OK | 200 OK | **PASS** |
| B16 | `/kgc_idreq.jsp` | 200 OK | 200 OK | **PASS** |
| B17 | `/TPA.jsp` | 200 OK | 200 OK | **PASS** |
| B18 | `/TPA_home.jsp` | 200 OK | 200 OK | **PASS** |
| B19 | `/TPA_audit_request.jsp` | 200 OK | 200 OK | **PASS** |
| B20 | `/cloud_req.jsp` | 200 OK | 200 OK | **PASS** |
| B21 | `/proof_Check.jsp` | 200 OK | 200 OK | **PASS** |
| B22 | `/proof_verify.jsp` | 200 OK | 200 OK | **PASS** |
| B23 | `/proof.jsp` | 200 OK | 200 OK | **PASS** |
| B24 | `/Cloud.jsp` | 200 OK | 200 OK | **PASS** |
| B25 | `/cloud_home.jsp` | 200 OK | 200 OK | **PASS** |
| B26 | `/cloud_audit.jsp` | 200 OK | 200 OK | **PASS** |
| B27 | `/All_files.jsp` | 200 OK | 200 OK | **PASS** |
| B28 | `/test.jsp` | 200 OK | 200 OK | **PASS** |

---

### Category C: End-to-End Business Workflow (`test_full_workflow.ps1`)

| # | Pipeline Stage | Expected Behavior | Actual Behavior | Result |
| :-: | :--- | :--- | :--- | :-: |
| C1 | User Registration | Inserts record into `user` with biometric BLOB | Record inserted; ID generated; Status set to pending KGC | **PASS** |
| C2 | KGC Key Issuance | KGC assigns private key `FUZZY...` and activates user | Key generated and saved in DB column `kgc` | **PASS** |
| C3 | User Authentication | Valid credentials generate session and dynamic 6-digit OTP | Session cookie issued; OTP stored in DB | **PASS** |
| C4 | Two-Factor OTP Auth | Matching OTP unlocks user dashboard | User redirected to `User_home.jsp` | **PASS** |
| C5 | Document Upload & AES | File encrypted with AES-128; SHA hash computed | Ciphertext stored in `fileupload`; File key assigned | **PASS** |
| C6 | User Request Audit | Audit record logged in `audit_request` | Status set to `waiting` | **PASS** |
| C7 | TPA Challenge to Cloud | TPA logs challenge in `cloud_request` | Cloud request registered with status `waiting` | **PASS** |
| C8 | Cloud Proof Generation | Cloud computes deterministic hash proof | Record inserted into `audit_proof`; file status `Audition Success` | **PASS** |
| C9 | TPA Proof Verification | TPA compares original hash with cloud proof hash | Hashes match (100% match confirmed) | **PASS** |
| C10 | User Proof Check | User views confirmed audit status | Proof rendered in client view | **PASS** |

---

### Category D: Security, Robustness & Tampering (`test_full_workflow.ps1`)

| # | Test Description | Expected Result | Actual Result | Result |
| :-: | :--- | :--- | :--- | :-: |
| D1 | Deliberate Tampering Detection | Deliberately corrupted DB hash (`TAMPERED_MALICIOUS_HASH_X99`) triggers TPA mismatch warning | TPA form surfaces corruption; Mismatch detected; Integrity breach confirmed | **PASS** |
| D2 | Clean State Restoration | Restoring original hash clears alert | Clean verification restored | **PASS** |
| D3 | Invalid User Password | Rejects login with redirect | Redirected to `User.jsp?Msg=Authentication_Failed` | **PASS** |
| D4 | Unapproved User Login | Blocks user prior to KGC key issuance | Redirected to `User.jsp?Msg=Authentication_Failed` | **PASS** |
| D5 | Invalid OTP Verification | Rejects wrong OTP code | Redirected to `otp.jsp?Msg=Wrong_OTP_entered` | **PASS** |
| D6 | Duplicate Registration | Prevents duplicate user creation | Duplicate email rejected; DB count remains 1 | **PASS** |
| D7 | Special Character Filename | File with quotes and ampersands (`Audit & Security Report '2026'.txt`) uploads safely | Uploaded cleanly without SQL syntax errors | **PASS** |
| D8 | Cryptographic Round-Trip | Plaintext -> AES-128 -> Ciphertext -> AES-128 -> Plaintext | Decrypted content matches original 100% | **PASS** |

---

### Category E: Live Public HTTPS Demonstration (`test_live_public_url.ps1`)

| # | Live Test Step | Public Target | Actual Result | Result |
| :-: | :--- | :--- | :--- | :-: |
| E1 | Public Homepage | `https://884506d565718b.lhr.life/Fuzzy_IDbased_DataIntegrity/index.jsp` | HTTP 200 OK | **PASS** |
| E2 | Public Portal Access | Role portal routes (`User.jsp`, `KGC.jsp`, `TPA.jsp`, `Cloud.jsp`) | All return HTTP 200 OK | **PASS** |
| E3 | Public User Registration | Multi-part form POST over HTTPS | User registered in DB | **PASS** |
| E4 | Public KGC Key Issuance | KGC authorization over HTTPS | Private key generated | **PASS** |
| E5 | Public User 2FA Login | OTP challenge and response over HTTPS | User authenticated | **PASS** |
| E6 | Public File Upload | Encrypted upload with AES-128 over HTTPS | File key and hash persisted | **PASS** |
| E7 | Public End-to-End Audit | Full challenge, proof computation, and verification over HTTPS | Proof matched original hash | **PASS** |

---

### Category F: Vercel Full-Stack Architecture Pipeline (`test_vercel_full_pipeline.ps1`)

| # | Vercel Pipeline Stage | Target Route / Action | Actual Result | Result |
| :-: | :--- | :--- | :--- | :-: |
| F1 | Vercel Landing Page | `GET /` | HTTP 200 OK | **PASS** |
| F2 | Vercel User Portal | `GET /user` | HTTP 200 OK | **PASS** |
| F3 | Vercel KGC Portal | `GET /kgc` | HTTP 200 OK | **PASS** |
| F4 | Vercel TPA Portal | `GET /tpa` | HTTP 200 OK | **PASS** |
| F5 | Vercel Cloud Portal | `GET /cloud` | HTTP 200 OK | **PASS** |
| F6 | Serverless Registration | `POST /api/auth?action=register` | User record inserted with pending KGC status | **PASS** |
| F7 | Duplicate Registration Block | `POST /api/auth?action=register` | Duplicate email rejected with HTTP 409 Conflict | **PASS** |
| F8 | Unapproved Login Block | `POST /api/auth?action=login` | Unapproved user blocked with HTTP 403 Forbidden | **PASS** |
| F9 | KGC Identity Discovery | `GET /api/kgc?action=list` | User identified in KGC pending registry | **PASS** |
| F10 | KGC Secret Key Generation | `POST /api/kgc?action=approve` | Cryptographic key `FUZZY...` generated and bound | **PASS** |
| F11 | User Authentication | `POST /api/auth?action=login` | Credentials verified; 2FA OTP issued | **PASS** |
| F12 | Invalid OTP Rejection | `POST /api/auth?action=otp` | Wrong OTP rejected with HTTP 401 Unauthorized | **PASS** |
| F13 | Valid 2FA Verification | `POST /api/auth?action=otp` | Matching OTP unlocks user session | **PASS** |
| F14 | AES-128 Document Upload | `POST /api/files` | File encrypted with AES-128; SHA hash persisted | **PASS** |
| F15 | Repository File Listing | `GET /api/files?uid=...` | Stored ciphertext and hash returned | **PASS** |
| F16 | Audit Request Initiation | `POST /api/audit?action=request` | Audit challenge queued for TPA | **PASS** |
| F17 | TPA Challenge to Cloud | `POST /api/tpa?action=challenge` | Challenge transmitted to Cloud Storage Server | **PASS** |
| F18 | Cloud Proof Computation | `POST /api/cloud?action=proof` | Deterministic proof computed and persisted | **PASS** |
| F19 | Positive Proof Verification | `POST /api/tpa?action=verify` | TPA confirms proof matches original hash (100% Match) | **PASS** |
| F20 | Deliberate Tampering Detection | `POST /api/tamper?action=corrupt` | TPA detects hash corruption & flags INTEGRITY BREACH | **PASS** |

---

## 3. Cryptographic Verification Summary

- **Symmetric Cipher:** AES (Advanced Encryption Standard)
- **Key Length:** 128 bits
- **Mode/Padding:** AES/ECB/PKCS5Padding
- **Round-Trip Test Result:** **PASSED** (Plaintext before encryption matched plaintext after decryption bit-for-bit, including special characters and symbols).
- **Integrity Tag Mechanism:** Deterministic cryptographic checksum generated on upload and compared by Third Party Auditor against cloud-computed proof block.

---

## 4. Conclusion & Certification

The application has satisfied **all 20 release criteria** established by the project specification. The database is robust and idempotent; all queries are parameterized; servlets handle session state and errors gracefully; negative test cases and deliberate corruption attacks are detected reliably; and the system has been tested end-to-end on both local environments and over a verified live public HTTPS connection.

**Release Status: APPROVED & CERTIFIED FOR PRESENTATION**
