# Product Requirements Document
## Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage System
### VTU 7th Semester Major Project Phase II — BCS786 — R R Institute of Technology

---

## 1. Document Information

| Field | Value |
|---|---|
| Project Name | Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage System |
| Document Title | Product Requirements Document (PRD) |
| Version | 1.1 (corrected academic identity) |
| Date | August 25, 2026 |
| Prepared For | Project team / downstream AI coding assistant |
| Project Type | VTU Major Project Work Phase II |
| Course / Project Code | BCS786 |
| Semester | 7th Semester |
| Institution | R R Institute of Technology |
| Project Team | Kiran B C (1RI23CS067), Kishor K (1RI23CS068), Chandan Malik (1RI23CS028), Anil Kumar Parida (1RI23CS009) |
| Guide | Prof. Prashanthkumar L |
| Academic Context | VTU 7th Semester Major Project Phase II — BCS786, R R Institute of Technology (see note below on source-document contamination) |
| Status | Draft — corrected identity, technical content retained from v1.0 |

> **Note — source-document contamination (formerly "CONFLICT-001"):**
> The uploaded source documents (notably `Synopsis.docx`) contain academic/personal identity details — a different student's name, USN, guide, college, university, and degree — that belong to **another, unrelated project** and do **not** apply to this team's submission. Those details have been treated as **contaminated source material**, not as this project's real academic identity, and have been removed from this PRD (see the Cover-Page / Report Information section and the Change Log at the end of this document). The **authoritative identity** for this project is: VTU 7th Semester Major Project Phase II, course code **BCS786**, at **R R Institute of Technology**, team **Kiran B C, Kishor K, Chandan Malik, Anil Kumar Parida**, guided by **Prof. Prashanthkumar L**. If any of the underlying `.docx` source files still contain the other student's identity information, those files should be corrected at the source before final report compilation — this PRD's identity content should be treated as authoritative going forward.

---

## 1A. Cover-Page / Report Information (Authoritative Academic Identity)

This section is the **single source of truth** for this project's academic identity and should be used to populate the cover page of the final report, all chapter headers, and any submission portal fields.

**Project Title:** Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage System

**Academic Context:** VTU 7th Semester Major Project Work Phase II

**Course / Project Code:** BCS786

**Institution:** R R Institute of Technology

### Project Team

| Sl. No. | Name | USN |
|---|---|---|
| 1 | KIRAN B C | 1RI23CS067 |
| 2 | KISHOR K | 1RI23CS068 |
| 3 | CHANDAN MALIK | 1RI23CS028 |
| 4 | ANIL KUMAR PARIDA | 1RI23CS009 |

### Guide

**Prof. Prashanthkumar L**

> **Contamination notice:** The originally uploaded source documents (in particular `Synopsis.docx`) contain a different student's name, USN, guide, and college/university information. That information belongs to an unrelated project and has been excluded from this PRD. It should also be removed from the underlying `.docx` report chapters before final compilation/printing.

---

## 2. Executive Summary

This project is a Java/JSP web application that lets users store files in cloud storage while allowing a Third Party Auditor (TPA) to verify — without downloading the files — that the cloud server is still storing them correctly and has not corrupted or lost them. The novel part, based on the accompanying research paper (Abstract/Synopsis), is **how encryption/verification keys are issued**: instead of traditional certificate-based public-key infrastructure (which is expensive to manage and requires trusting a Certificate Authority), the system uses a **fuzzy identity-based** scheme where a user's **biometric data** acts as their identity. A Key Generation Center (KGC) issues a private key tied to this biometric identity, and the scheme tolerates small variations between the biometric sample used at key generation and at verification time ("error tolerance").

Four actors use the system: **User (Data Owner)**, **KGC**, **TPA**, and **Cloud Server**. A user registers with personal details plus a biometric image, is approved by the KGC (which issues a private key delivered by email), uploads files to the cloud with a hash generated at upload time, and can later request an audit. The TPA relays the audit challenge to the cloud server, the cloud server responds with a proof, and the result confirms whether the stored file is still intact.

This is an **academic proof-of-concept/prototype** (the Abstract explicitly calls it a "prototype implementation... to demonstrate practicality"), not a production cloud storage product. It is intended to be built, demonstrated, and defended in a viva, with working screens for registration, login, key issuance, file upload, audit request, and proof verification — all of which already exist as screenshots of a working prior implementation (see Section 45, Source-to-Requirement Mapping).

---

## 3. Project Background

**Domain:** Cloud computing security, specifically remote data integrity auditing / provable data possession, combined with identity-based cryptography and biometrics.

**Current situation:** Cloud storage is now common for outsourcing data storage and computation. Once data leaves the user's own infrastructure, the user needs a way to be confident the cloud provider still holds an unmodified copy — without having to download everything back (which defeats the purpose of outsourcing storage in the first place).

**Motivation:** Existing "remote data integrity checking" (RDIC) protocols — Provable Data Possession (PDP), Proofs of Retrievability (PoR) — solve the "verify without downloading" problem, but they typically rely on traditional public-key infrastructure (PKI) with digital certificates. Certificate issuance, distribution, storage, and revocation is operationally complex and computationally expensive, and it requires unconditional trust in a Certificate Authority (CA) — a trust assumption the source material calls out as sometimes unrealistic. The project's motivation is to remove this certificate-management burden.

**Context:** The proposed approach borrows from **Fuzzy Identity-Based Encryption** (Sahai & Waters) and applies it to the RDIC/auditing setting, using **biometric data** as the "fuzzy identity" so that certificates are not needed and key issuance tolerates natural biometric sample variation.

---

## 4. Problem Statement

**Existing problem:** Remote data integrity auditing protocols built on classical PKI require generating, distributing, storing, and revoking digital certificates for every user, and require the verifier to trust a Certificate Authority. This is administratively and computationally expensive and does not scale cleanly.

**Root cause:** Certificate-based public-key cryptography ties a user's public key to their identity through a third-party-signed certificate, which must be individually managed for its whole lifecycle.

**Affected users:** Cloud storage users (data owners) who need their data integrity audited, and any organization operating or relying on a certificate-based RDIC/auditing deployment.

**Limitations of current solutions:**
- Complex, costly certificate lifecycle management (generation, distribution, revocation) — `Source: SYSTEM_ANALYSIS.docx`.
- Scalability challenges as user count grows — `Source: SYSTEM_ANALYSIS.docx`.
- A potentially unrealistic level of trust required in the CA — `Source: SYSTEM_ANALYSIS.docx`.
- Traditional identity-based cryptography (which drops certificates) still uses a single, exact identity string (e.g., an email address) as the public key, and is not designed to tolerate identity data that varies slightly between readings — a gap that matters once biometric data is used as identity.

**Consequences:** Higher operational cost and complexity for anyone deploying certificate-based data-auditing systems at scale, and brittle authentication if biometric identity were used naively (since biometric readings are never bit-for-bit identical between captures).

---

## 5. Proposed Solution

**Overall solution:** A **fuzzy identity-based data integrity auditing** protocol in which a user's identity is represented as a **set of descriptive attributes derived from biometric data**, rather than a certificate. The Key Generation Center (KGC) issues a private key bound to this attribute-based identity using a master secret key. Verification succeeds if the identity used to generate the response is **"sufficiently close"** to the identity used to generate the original key — this is the **error-tolerance** property.

**Main approach:**
1. Replace CA-issued certificates with KGC-issued, attribute/biometric-bound private keys (removing certificate management overhead).
2. Allow small variation between the biometric identity at key-issue time and at verification time (fuzziness/error tolerance), instead of requiring an exact match.
3. Use a challenge–response auditing protocol between the TPA and the Cloud Server so the data owner/TPA can verify file integrity without downloading the file.

**Major capabilities:**
- Attribute/biometric-based user registration and key issuance (via KGC).
- File upload to cloud storage with hash generation for later integrity checking.
- On-demand audit requests, TPA-mediated challenge/response with the cloud server.
- Proof generation by the cloud server and proof verification, confirming (or failing to confirm) that the stored file is unmodified.

**Expected benefits:**
- Simplified key management vs. certificate-based PKI (no CA, no certificate lifecycle).
- Formally provable security: the paper proves **soundness** (a dishonest cloud server cannot convince a verifier it holds the file unless it actually does, with high probability) based on the **Computational Diffie-Hellman (CDH)** assumption and the **Discrete Logarithm** assumption, in the **selective-ID security model** — `Source: ABSTRACT.docx`.
- Practical demonstrability via a working prototype implementation — `Source: ABSTRACT.docx`.

**How it addresses the problem:** By eliminating the certificate as the anchor of identity and trust, and substituting a biometric-derived fuzzy identity with formally analyzed security guarantees, the system removes the specific pain points (cost, complexity, CA trust) identified in the existing-system analysis.

---

## 6. Objectives

### Primary Objectives
1. Implement user registration and biometric-based identity capture, with KGC-mediated private key issuance (no certificate authority).
2. Implement file upload to cloud storage with hash-based integrity metadata generated at upload time.
3. Implement a TPA-mediated audit request → challenge → response → proof workflow between User, TPA, and Cloud Server.
4. Demonstrate that the system correctly identifies whether cloud-stored data is intact (i.e., the auditing/proof check functions correctly for unmodified data).

### Secondary Objectives
1. Provide role-based login (User, KGC, TPA, Cloud Server) with separate dashboards per role.
2. Provide an email-based delivery channel for the private key and, where used, an email OTP step during user login.
3. Provide a viewable audit trail (uploaded files, hash codes, upload/audit timestamps) to each relevant role.
4. `NEEDS CLARIFICATION`: whether "measurable" targets (response time, concurrent users, etc.) are required for grading — none are specified in the source material (see Section 31).

---

## 7. Scope

### In Scope
- User registration with personal details + biometric (image) capture.
- KGC approval workflow and private-key issuance/delivery via email.
- User login with password, plus an OTP verification step (per screenshots).
- File upload with file naming and hash/metadata generation.
- Viewing of a user's own uploaded files.
- Audit request initiated by the user for an uploaded file.
- TPA login, receipt of audit requests, and forwarding of audit/challenge to the Cloud Server.
- Cloud Server login, listing of stored files, and generation/sending of an auditing proof.
- Proof check / verification result shown back to the requesting party.

### Out of Scope
- Real deployment to a commercial or multi-tenant public cloud (this is a local/prototype cloud server simulation, per Hardware/Software requirements and screenshots showing `localhost`).
- Payment, billing, or storage-quota management.
- File-level access control / sharing between multiple end users beyond what is shown (the "approve/reject file request from other users" behavior in `IMPLEMENTATION.docx`'s User module is flagged as **NEEDS CLARIFICATION** — see CONFLICT-002 below).
- Mobile native apps (Future Scope only, per Synopsis Future Enhancement chapter).
- Blockchain integration, AI-based threat detection, multi-cloud support (explicitly Future Enhancement in Synopsis Ch. 6).

### Future Scope (explicitly listed in `Synopsis.docx`, Chapter 6 — do NOT implement now)
- Blockchain integration for tamper-proof auditing.
- Advanced biometric authentication (fingerprint, iris, facial recognition) beyond the current single biometric upload.
- AI-based threat/anomaly detection.
- Multi-cloud support.
- Improved key management for large-scale users.
- Mobile and web integration improvements.
- Performance optimization of computation/communication overhead.

> **CONFLICT-002 (Scope conflict inside the User module description):**
> `IMPLEMENTATION.docx` and `Synopsis.docx` both describe the **User module** as: *"User can approve or reject the file request sent by other users. After request approval data user will send the secret key and verification object through mail."*
> This describes the **data owner approving other users' access/decryption requests** and personally emailing a secret key — a **file-sharing/access-control feature**. But the KGC module description and the screenshots show a **different** key-issuance flow: the **KGC** (not the data owner) approves registrations and issues the private key by email. No registration/approval screen for "other users requesting a file" was found among the 15 screenshots, and no such screen is described elsewhere.
> `NEEDS CLARIFICATION`: Is the "approve/reject file request" feature (a) an actual planned feature not yet screenshotted, (b) leftover boilerplate text copied from a different (file-sharing) project template, or (c) a mis-description of the KGC's approval step? This PRD treats it as `OPTIONAL`/unconfirmed and excludes it from Section 11 Functional Requirements' MVP set until clarified.

---

## 8. Stakeholders

| Stakeholder | Role | Interest | Responsibilities | Interaction with System |
|---|---|---|---|---|
| Kiran B C (1RI23CS067) | Student / Developer | Complete and successfully defend the project | Design, build, test, document, present | Builds and operates all roles for demo |
| Kishor K (1RI23CS068) | Student / Developer | Complete and successfully defend the project | Design, build, test, document, present | Builds and operates all roles for demo |
| Chandan Malik (1RI23CS028) | Student / Developer | Complete and successfully defend the project | Design, build, test, document, present | Builds and operates all roles for demo |
| Anil Kumar Parida (1RI23CS009) | Student / Developer | Complete and successfully defend the project | Design, build, test, document, present | Builds and operates all roles for demo |
| Prof. Prashanthkumar L | Project Guide | Academic supervision, correctness of approach | Reviews design/security claims, guides implementation | Reviews documentation and demo |
| R R Institute of Technology | Institution | Academic ownership of the project deliverable | Provides evaluation framework (BCS786, 7th Sem Major Project Phase II) | Not a system user; consumes documentation/demo |
| Data Owner / User | End user (primary actor) | Store files securely and get proof of integrity | Register, upload files, request audits | Uses User role screens |
| KGC (Key Generation Center) | System-internal trusted authority actor | Correct key issuance | Approve users, issue private keys | Uses KGC role screens |
| TPA (Third Party Auditor) | Independent verifier actor | Verify integrity impartially | Relay audit requests/challenges | Uses TPA role screens |
| Cloud Server / Cloud Provider | Storage provider actor | Prove correct storage without exposing/downloading data | Store files, respond to challenges with proofs | Uses Cloud Server role screens |
| Evaluators / Examiners (viva panel) | Academic assessors | Confirm the work meets project standards | Assess documentation, demo, and defense | Not a system user; consumes documentation/demo |

---

## 9. User Roles

The system has **four** distinct roles, each with its own login and dashboard — this is confirmed directly by the screenshots (separate `User.jsp`, `KGC.jsp`, `TPA.jsp`, `Cloud.jsp` login pages and separate post-login navigation tabs).

| Role | Purpose | Permissions | Main Actions | Restrictions |
|---|---|---|---|---|
| **User (Data Owner)** | Owns and audits their own data | Register, log in (with OTP), upload files, view own files, request audits, check proofs | Registration, File Upload, My Files, Audit Request, Proof Check | Cannot view other users' files; cannot self-issue keys |
| **KGC** | Issues cryptographic identity/keys | View registered users & their biometric submissions, approve/reject registration, issue private key | KGC Home (pending approvals), Key Request, Users list | `NEEDS CLARIFICATION`: whether KGC account is self-registrable or pre-provisioned — screenshots show only a login, no KGC registration screen, so this PRD **assumes** (`ASSUMPTION-001`) KGC is a single pre-provisioned/admin-style account |
| **TPA** | Independent auditor | Receive audit requests, forward challenge to Cloud Server, view hash code / verify | TPA login, audit relay | `ASSUMPTION-001` also applies: TPA appears pre-provisioned (login only, no registration screen found) |
| **Cloud Server / Cloud Provider** | Stores files, responds to audits | View stored files, generate and send auditing proof | Files in Cloud, Send Proof | `ASSUMPTION-001` also applies: Cloud Server appears pre-provisioned (login only, no registration screen found) |

`ASSUMPTION-001`: KGC, TPA, and Cloud Server are single, pre-provisioned "system-role" accounts (akin to admin accounts) rather than something end users self-register for, since only the User role has a visible registration screen among the 15 provided screenshots.

---

## 10. User Personas

Because this is a small, four-role academic prototype rather than a consumer product with varied user types, only one realistic external-facing persona is warranted; the other three roles are single system-operator accounts (see `ASSUMPTION-001`) and are not given personas.

> **Note:** The persona below is a **sample/demo end-user** derived from the sample data visible in the application screenshots. It represents someone who would *use* the finished system, and is unrelated to and must not be confused with the actual student project team (Kiran B C, Kishor K, Chandan Malik, Anil Kumar Parida — see Section 8 and the Cover-Page / Report Information section).

**Persona: Data Owner ("Naresh") — sample/demo application user, not a project author**
- **Role:** User / Data Owner (name derived from the sample data visible in screenshots, e.g. `naresh.joinfotech@gmail.com`)
- **Goals:** Store a file in the cloud and later be confident it hasn't been altered or lost, without re-downloading it to check.
- **Problems:** Doesn't want to manage complex PKI certificates or trust a third party blindly; wants a simple registration and a lightweight way to prove integrity.
- **Expected system usage:** Registers once (with biometric image), gets approved and receives a private key by email, uploads files, occasionally requests an audit and checks the proof result.
- **Technical skill level:** General computer user; comfortable with web forms and email, not expected to understand the underlying cryptography.

---

## 11. Functional Requirements

Requirements are grouped by module. Priority: **Must Have (M)**, **Should Have (S)**, **Could Have (C)**.

| ID | Name | Description | Actor | Preconditions | Main Behavior | Expected Result | Postconditions | Priority | Dependencies | Acceptance Criteria |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-001 | User Registration | User submits name, email, phone, DOB, gender, city, country, password, confirm password, and a biometric image file | User | User not already registered | System validates and stores form + biometric file | "Registration successful" confirmation shown | New user record created, status = pending KGC approval | M | — | Submitting valid data creates a pending user record and shows a success message (matches screenshot) |
| FR-002 | KGC Views Pending Registrations | KGC reviews users awaiting approval, including their submitted biometric thumbnail | KGC | KGC logged in | System lists DO Name, DO Mail, Status, Biometric thumbnail, Action | Table of pending/approved users displayed | — | M | FR-001 | KGC Home page lists all registered users with status and an approve action, matching screenshot |
| FR-003 | KGC Approves User & Issues Private Key | KGC approves a pending user, triggering private key generation bound to the user's fuzzy/biometric identity | KGC | Pending user exists | KGC clicks Approve/Action; system generates private key using master secret key + user attributes; emails key to user | Private key delivered to user's registered email (e.g., "Private Key: FUZZY160020321") | User status becomes approved; private key recorded/associated with user | M | FR-001, FR-002 | Approving a user sends an email containing a private key string to that user's registered address |
| FR-004 | User Login | Registered user logs in with email and password | User | User approved (status active) | System validates credentials | Redirect to OTP verification | Session started only after OTP step (FR-005) | M | FR-001 | Valid credentials proceed to OTP screen; invalid credentials rejected |
| FR-005 | Email OTP Verification | After password login, user must enter an OTP sent to their email | User | FR-004 completed | System sends OTP to email, user enters code | On correct OTP, user reaches their dashboard | Authenticated session created | M | FR-004 | Correct OTP grants dashboard access; incorrect/expired OTP is rejected |
| FR-006 | File Upload | User uploads a file, providing a file name and selecting a file via file picker | User | User authenticated | System stores file in cloud storage, generates a hash and file ID, records upload timestamp | File appears in "My Files" / cloud file listing with hash code | New file record with Hash_Code and Uploaded_Time created | M | FR-004, FR-005 | Uploading a file produces a listed file with file ID, timestamp, and hash code (matches screenshot) |
| FR-007 | View My Files | User views the list of files they have uploaded | User | FR-006 has occurred at least once | System lists user's files | Table of files shown | — | S | FR-006 | "My Files" tab displays uploaded files for the logged-in user |
| FR-008 | Request Audit | User requests an integrity audit for a specific uploaded file | User | File exists (FR-006) | User clicks "Audit Request" against a file row; request routed to TPA | Request appears in TPA's queue | Audit request record created (User Name, File Id, Uploaded_Time, Hash_Code) | M | FR-006 | Clicking Audit Request on a file creates a request visible to TPA (matches screenshot table columns) |
| FR-009 | TPA Login | TPA logs in with name/password | TPA | TPA account provisioned (`ASSUMPTION-001`) | System validates credentials | TPA dashboard shown | Authenticated session | M | `ASSUMPTION-001` | Valid TPA credentials grant access to TPA dashboard |
| FR-010 | TPA Relays Audit Challenge | TPA forwards a received audit request as a challenge to the Cloud Server | TPA | FR-008 request exists | TPA sends audit/challenge request to Cloud Server | Cloud Server receives challenge | Challenge logged | M | FR-008, FR-009 | An audit request results in a challenge sent to the Cloud Server |
| FR-011 | Cloud Server Login | Cloud Server operator logs in with name/password | Cloud Server | Cloud account provisioned (`ASSUMPTION-001`) | System validates credentials | Cloud dashboard shown | Authenticated session | M | `ASSUMPTION-001` | Valid credentials grant access to Cloud Server dashboard |
| FR-012 | View Files in Cloud | Cloud Server operator views all files currently stored | Cloud Server | FR-006 has occurred | System lists User ID, File ID, Time, Hash Value | Table displayed | — | S | FR-006 | "Files in Cloud" tab lists stored files with hash values (matches screenshot) |
| FR-013 | Send Auditing Proof | Cloud Server responds to a challenge by generating and sending a proof of storage | Cloud Server | FR-010 challenge received | Cloud Server computes response/proof from stored file and sends it | Proof delivered to TPA / auditing pipeline | Proof/response recorded | M | FR-010 | "Send Auditing Proof" action on a challenged file returns a proof value |
| FR-014 | Proof Check / Verification Result | User (or TPA) checks whether the returned proof confirms the file is intact | User / TPA | FR-013 completed | System verifies proof against expected value using the auditing protocol | Pass/fail integrity result shown | Audit outcome recorded | M | FR-013 | "Proof Check" tab shows a verification result for a previously requested audit |
| FR-015 | KGC — Key Request Tab | KGC can view/manage private-key issuance requests separately from the approval home screen | KGC | KGC logged in | System lists key requests | Table/screen shown | — | C | FR-003 | "Key Request" tab is reachable and displays key-issuance-related data |
| FR-016 | KGC — Users Tab | KGC can view a full list of all registered users, not only pending ones | KGC | KGC logged in | System lists all users regardless of status | Table shown | — | C | FR-001 | "Users" tab shows all registered users |
| FR-017 (`NEEDS CLARIFICATION`) | Data-Owner-to-User File Access Approval | Data owner approves/rejects another user's request to access a file and emails them a secret key + verification object | User | Another user has requested access | Owner approves/rejects; system emails secret key/verification object | Access granted/denied | — | `OPTIONAL` | FR-006 | Not implemented until CONFLICT-002 is resolved with the student/guide |

---

## 12. User Stories

**US-001** — As a **User**, I want to **register with my personal details and a biometric image**, so that **the system can later issue me a fuzzy-identity-based private key without requiring a certificate**.
- Acceptance criteria: Registration form accepts all required fields + biometric file; success message shown; record appears in KGC's pending list.
- Priority: Must Have
- Related FR: FR-001

**US-002** — As a **KGC operator**, I want to **review and approve a user's registration**, so that **the user receives a private key bound to their biometric identity**.
- Acceptance criteria: Approval action sends an email containing a private key to the user.
- Priority: Must Have
- Related FR: FR-002, FR-003

**US-003** — As a **User**, I want to **log in with my password and confirm an emailed OTP**, so that **my account has an extra layer of protection beyond a static password**.
- Acceptance criteria: Correct password + correct OTP grants dashboard access; either failing blocks access.
- Priority: Must Have
- Related FR: FR-004, FR-005

**US-004** — As a **User**, I want to **upload a file to cloud storage and see its hash code**, so that **I have a reference value to later confirm integrity against**.
- Acceptance criteria: File appears with file ID, timestamp, hash code after upload.
- Priority: Must Have
- Related FR: FR-006

**US-005** — As a **User**, I want to **request an audit of a file I've uploaded**, so that **I can confirm it hasn't been altered or lost, without downloading it**.
- Acceptance criteria: Audit Request action on a file creates a request the TPA can see.
- Priority: Must Have
- Related FR: FR-008

**US-006** — As a **TPA**, I want to **forward a user's audit request as a challenge to the cloud server**, so that **I can independently verify the integrity claim**.
- Acceptance criteria: A pending audit request results in a challenge visible/actionable on the Cloud Server side.
- Priority: Must Have
- Related FR: FR-010

**US-007** — As a **Cloud Server operator**, I want to **respond to an audit challenge with a proof**, so that **the TPA/user can confirm the file is intact without me exposing the raw file**.
- Acceptance criteria: "Send Auditing Proof" produces a proof value tied to the challenged file.
- Priority: Must Have
- Related FR: FR-013

**US-008** — As a **User**, I want to **see a pass/fail result for my audit request**, so that **I know whether my data is still intact**.
- Acceptance criteria: Proof Check screen shows a clear result for a completed audit.
- Priority: Must Have
- Related FR: FR-014

---

## 13. Use Cases

**UC-001 — User Registration**
- Primary actor: User. Supporting actor: none (system).
- Preconditions: User has a valid email and a biometric image file available.
- Trigger: User opens registration form and submits details.
- Main flow: Fill form → attach biometric file → submit → system validates → record created with "pending" status → success message shown.
- Alternative flow: Missing/invalid field → inline validation error → user corrects and resubmits.
- Exception flow: Email already registered → system rejects with duplicate-account error (`NEEDS CLARIFICATION`: exact duplicate-handling behavior not shown in screenshots).
- Postconditions: Pending registration visible to KGC.

**UC-002 — KGC Approval & Key Issuance**
- Primary actor: KGC. Supporting actor: User (receives email).
- Preconditions: A pending registration exists.
- Trigger: KGC opens KGC Home and selects Approve on a user row.
- Main flow: KGC approves → system derives private key from master secret + user's biometric attributes → email sent to user with key.
- Alternative flow: KGC rejects → user status set to rejected, no key issued (`NEEDS CLARIFICATION`: no reject screen explicitly captured in screenshots, inferred from "approve or reject" wording elsewhere).
- Exception flow: Email delivery failure → `NEEDS CLARIFICATION` on retry/error handling (not documented).
- Postconditions: User can now log in.

**UC-003 — File Upload**
- Primary actor: User.
- Preconditions: User authenticated (password + OTP).
- Trigger: User opens File Upload tab.
- Main flow: Enter file name → select file → click Upload → system stores file, computes hash, timestamps it.
- Alternative flow: Unsupported file type/size (`NEEDS CLARIFICATION`: no constraints documented).
- Exception flow: Upload failure (network/storage) → error shown (`NEEDS CLARIFICATION`: exact message not documented).
- Postconditions: File listed in My Files and Files in Cloud.

**UC-004 — Audit Request and Verification**
- Primary actor: User. Supporting actors: TPA, Cloud Server.
- Preconditions: File already uploaded (UC-003 complete).
- Trigger: User clicks Audit Request on a file.
- Main flow: Request sent to TPA → TPA forwards challenge to Cloud Server → Cloud Server computes and sends proof → verification result returned to requester (User/TPA) via Proof Check.
- Alternative flow: File found intact → "pass"/success result.
- Exception flow: File found tampered/missing, or cloud server fails to respond in time → "fail" result / error (`NEEDS CLARIFICATION`: exact failure UX not documented).
- Postconditions: Audit result recorded and viewable.

---

## 14. Non-Functional Requirements

| ID | Category | Requirement | Notes |
|---|---|---|---|
| NFR-001 | Security | Private keys must be bound to biometric/attribute-based identity and generated only by the KGC using its master secret key | `Source: Synopsis.docx / ABSTRACT.docx` |
| NFR-002 | Security | The protocol's soundness must rest on the Computational Diffie-Hellman assumption and the Discrete Logarithm assumption in the selective-ID security model | `Source: ABSTRACT.docx` |
| NFR-003 | Security | Uploaded files must be hashed at upload time to support later integrity verification | `Source: Synopsis.docx` (IMPLEMENTATION, User module) |
| NFR-004 | Security | User login should require a second factor (email OTP) in addition to password | Observed in screenshots; `NEEDS CLARIFICATION` on OTP expiry/retry rules |
| NFR-005 | Usability | Error tolerance: verification must succeed when the biometric identity used at verification is "sufficiently close" to (not necessarily identical to) the one used at key issuance | Core differentiator; `Source: ABSTRACT.docx` |
| NFR-006 | Reliability | The auditing/proof mechanism must correctly distinguish intact vs. tampered/missing data (soundness) | `Source: ABSTRACT.docx / SYSTEM_ANALYSIS.docx` |
| NFR-007 | Performance | `NEEDS CLARIFICATION` — no response-time, throughput, or concurrency targets are specified anywhere in the source material |  |
| NFR-008 | Compatibility | Application should run on the specified OS/software stack (see Section 26) | `Source: SYSTEM_SPECIFICATION.docx` |
| NFR-009 | Maintainability | Code should separate the four actor roles (User/KGC/TPA/Cloud) into distinct modules, matching the module breakdown already used in documentation | `Source: IMPLEMENTATION.docx` |
| NFR-010 | Data Integrity | Hash codes recorded at upload must be immutable reference values used for later comparison during audits | Inferred from screenshots (Hash_Code / Hash Value columns) |
| NFR-011 | Privacy | Biometric images submitted at registration should be handled as sensitive personal data | `NEEDS CLARIFICATION`: no storage/retention/encryption-at-rest policy is documented for the biometric file itself |

---

## 15. System Modules

| Module ID | Module Name | Purpose | Responsibilities | Main Features | Inputs | Outputs | Dependencies | Related FRs |
|---|---|---|---|---|---|---|---|---|
| MOD-01 | User Module | Data owner interactions | Registration, login, file upload, audit requests, viewing files | Registration form (incl. biometric upload), OTP login, File Upload, My Files, Audit Request, Proof Check | Personal details, biometric file, files to upload | Uploaded file records, audit requests, proof results | KGC Module (key issuance), Cloud Module (storage) | FR-001, FR-004–FR-008, FR-014 |
| MOD-02 | KGC Module | Identity & key management | Approve users, issue biometric-bound private keys | KGC Home (pending list), Key Request, Users | Pending registrations | Approval decisions, emailed private keys | User Module | FR-002, FR-003, FR-015, FR-016 |
| MOD-03 | TPA Module | Independent auditing relay | Receive audit requests, challenge cloud server, relay results | TPA login, audit relay/verification | Audit requests from User Module | Challenges to Cloud Module, verification results | User Module, Cloud Module | FR-009, FR-010 |
| MOD-04 | Cloud Server Module | Storage & proof generation | Store files, respond to challenges with proofs | Cloud login, Files in Cloud, Send Proof | Uploaded files, challenges from TPA | Stored file listing, auditing proofs | User Module, TPA Module | FR-011–FR-013 |

---

## 16. System Workflow

**Normal workflow — Registration & Key Issuance**
`User → Registration Form (incl. biometric) → Pending Status → KGC Reviews → KGC Approves → Private Key Emailed to User → User Can Log In`

**Normal workflow — Upload & Audit**
`User Login (password + OTP) → File Upload (hash generated) → File Listed (My Files / Files in Cloud) → User Sends Audit Request → TPA Relays Challenge to Cloud Server → Cloud Server Sends Auditing Proof → Proof Check Result Shown to User`

**Exception workflow — Failed OTP**
`User Login (password OK) → OTP Entry → Incorrect/Expired OTP → Access Denied → User Retries or Requests New OTP (`NEEDS CLARIFICATION` on retry mechanics)`

**Exception workflow — Failed/Tampered Audit**
`Audit Request → Challenge Sent → Cloud Server Responds → Verification Fails (data mismatch) → Failure Result Shown (`NEEDS CLARIFICATION` on exact remediation/notification behavior)`

---

## 17. Data Requirements

| Entity | Purpose | Key Attributes | Source | Destination | Relationships | Validation | Retention |
|---|---|---|---|---|---|---|---|
| User/DataOwner | Represents a registered data owner | Name, email, phone, DOB, gender, city, country, password, biometric image, status | User registration form | Application DB | 1-to-many with Files; 1-to-1 with issued Private Key | Required-field validation on registration (`NEEDS CLARIFICATION` on exact format rules, e.g. password strength) | `NEEDS CLARIFICATION` |
| PrivateKey | Cryptographic key bound to fuzzy/biometric identity | Key value/string (e.g., "FUZZY160020321"), associated user, issued-by KGC, issue date | KGC approval action | Emailed to user; possibly stored server-side | 1-to-1 with User | Must be generated only by KGC using master secret + attributes | `NEEDS CLARIFICATION` |
| File | Uploaded content whose integrity will be audited | File name, File ID, owner (User), upload timestamp, hash code | User File Upload | Cloud storage + DB metadata record | Many-to-1 with User; 1-to-many with Audit Requests | `NEEDS CLARIFICATION` on size/type limits | `NEEDS CLARIFICATION` |
| AuditRequest | A request to verify a file's integrity | User Name, File Id, Uploaded_Time, Hash_Code, status | User Audit Request action | TPA queue | Many-to-1 with File | Must reference an existing File | `NEEDS CLARIFICATION` |
| Challenge/Proof | The TPA→Cloud challenge and the resulting proof | Challenged File ID, Time, Hash Value, Proof/response value | TPA relay + Cloud Server response | Verification/Proof Check screen | 1-to-1 with AuditRequest | Proof must be checkable against expected hash/response | `NEEDS CLARIFICATION` |

---

## 18. Database Requirements (Conceptual)

**Conceptual entities:** User, PrivateKey, File, AuditRequest, Challenge/Proof (see Section 17).

**Conceptual relationships:**
- One User owns many Files.
- One User has (at most) one issued PrivateKey.
- One File can have many AuditRequests over time.
- One AuditRequest maps to one Challenge/Proof exchange.

**Important constraints:**
- A private key can only be created after KGC approval of a pending User.
- A File's hash code must be generated at upload time and treated as immutable thereafter.
- An AuditRequest must reference a File that already exists.

**CRUD requirements (conceptual, not final schema):**
- User: Create (register), Read (KGC/self), Update (status by KGC), Delete `NEEDS CLARIFICATION`.
- File: Create (upload), Read (owner + Cloud Server), Update `NEEDS CLARIFICATION` (should files be immutable once uploaded, for integrity purposes?), Delete `NEEDS CLARIFICATION`.
- AuditRequest/Proof: Create (on request/response), Read (User/TPA/Cloud), Update (status), Delete `NEEDS CLARIFICATION`.

`SYSTEM_SPECIFICATION.docx` and `Synopsis.docx` both state the database is **MySQL** (Confirmed — see CONFLICT-003 below for a contradicting mention).

> **CONFLICT-003 (Database technology conflict):**
> `SYSTEM_SPECIFICATION.docx` and `Synopsis.docx` list the database as **MYSQL**. However, `SOFTWARE_ENVIRONMENT.docx` states: *"Finally we decided to proceed the implementation using Java Networking. And for dynamically updating the cache table we go for MS Access database."* This directly contradicts the MySQL requirement.
> This PRD treats **MySQL as the Confirmed** database (it appears in the dedicated System Specification document twice, and is the more specific/authoritative source), and flags the MS Access mention as likely **leftover boilerplate text** from a different/generic Java project template that was reused when assembling `SOFTWARE_ENVIRONMENT.docx` (that document also contains large generic sections on ODBC, JFreeChart charting, and J2ME mobile development that do not otherwise correspond to any screenshot or feature in this project — see Section 25). `NEEDS CLARIFICATION` with the student to confirm MySQL is correct and the MS Access line can be disregarded.

---

## 19. API Requirements

No REST/HTTP API contract, endpoint list, or API-style architecture is documented anywhere in the source material. The evidenced implementation (screenshots) uses classic server-rendered JSP pages (`User.jsp`, `KGC.jsp`, `TPA.jsp`, `Cloud.jsp`, `File_Upload.jsp`, `audit_request.jsp`, `cloud_audit.jsp`, `keyreq.jsp`, `otp.jsp`, `All_files.jsp`) rather than a separate API layer.

`NEEDS CLARIFICATION`: If the rebuild targets a modern architecture (e.g., REST backend + frontend), the following conceptual capabilities would need concrete endpoints — but none should be invented as "confirmed" without the student's direction:
- Register user (incl. biometric upload)
- KGC: list pending users / approve user / issue key
- Login (+ OTP verification)
- Upload file
- List files (per user / per cloud)
- Create audit request
- TPA: relay challenge
- Cloud: submit proof
- Check proof/verification result

---

## 20. Authentication and Authorization

- **Registration:** Available for the User role only (per screenshots). `ASSUMPTION-001` applies to KGC/TPA/Cloud accounts (pre-provisioned).
- **Login:** Each of the 4 roles has its own login page/credentials (Name/Email + Password).
- **Second factor:** User login includes an email OTP step after password validation (per screenshot). `NEEDS CLARIFICATION` whether KGC/TPA/Cloud logins also use OTP — no such screen was captured for those roles.
- **Password requirements:** `NEEDS CLARIFICATION` — no complexity/length rules are documented.
- **Session/token requirements:** `NEEDS CLARIFICATION` — session management approach not documented (classic JSP session vs. token-based).
- **Roles:** User, KGC, TPA, Cloud Server (see Section 9).
- **Permissions:** Each role only accesses its own dashboard/tabs; cross-role access is not evidenced or intended.
- **Unauthorized behavior:** Screens show a login gate before role dashboards; `NEEDS CLARIFICATION` on the exact behavior for an unauthenticated direct URL access attempt.

---

## 21. UI/UX Requirements

Confirmed from the 15 provided screenshots of a working prior implementation:

**Main screens:**
- Home Page — project title/tagline banner + a diagram of the four-actor flow (User ↔ KGC, User ↔ TPA ↔ Cloud Server), with top navigation: Home Page, User, KGC, TPA, Cloud Server.
- User Login screen, with a "New User Registration" link.
- User Registration form: Name/Email, Phone (required), DOB (required), Gender (dropdown, required), City, Country, Password, Confirm Password, Biometric file chooser ("Bio-Metric", `.png`), Submit.
- OTP Verification screen (single OTP input + submit).
- User dashboard tabs: File Upload, My Files, Audit Request, Proof Check, Logout.
- File Upload screen: File Name field + drag-and-drop/"Select a file" control + Upload button.
- Audit Request table: User Name, File Id, Uploaded_Time, Hash_Code, Audit Request action link.
- KGC Login screen.
- KGC dashboard tabs: KGC Home Page, Key Request, Users, Logout.
- KGC Home table: DO Name, DO Mail, Status, Biometrics (thumbnail), Action (approve).
- TPA Login screen.
- Cloud Login screen.
- Cloud Server dashboard tabs: Send Proof, Files in Cloud, Logout.
- Cloud tables: User ID, File ID, Time, Hash Value, and (on the Send Proof tab) an Action column ("Send Auditing Proof").

**Navigation:** Top horizontal tab bar per role, with the active tab highlighted (orange), consistent across all four role dashboards.

**Forms:** Simple stacked-label input forms on a dark background theme, white input boxes.

**Notifications:** Browser `alert()` dialog used for at least "Registration successful" confirmation.

**Error messages / success messages:** `NEEDS CLARIFICATION` — only the registration-success alert was observed; no failure/error screens were included among the 15 screenshots.

**Responsive requirements:** `NEEDS CLARIFICATION` — screenshots are all desktop-browser captures; no mobile layout evidence.

This PRD does **not** prescribe a frontend framework beyond what is already evidenced (server-rendered JSP pages), per instruction not to invent frontend technology choices.

---

## 22. Validation Requirements

| Area | Rule (Confirmed / Needs Clarification) |
|---|---|
| Registration required fields | Phone, DOB, Gender are marked "(required)" on-screen; Name/Email, City, Country, Password/Confirm Password, Biometric file are present but required-flag not visible for all — `NEEDS CLARIFICATION` |
| Password confirmation | A "Confirm Password" field exists — assume it must match Password (`ASSUMPTION-002`) |
| Biometric file type | File chooser is scoped to `.png` per the screenshot label ("Choose File Nor .png") — `NEEDS CLARIFICATION` on exact accepted formats/size limits |
| Login | Email/Name + Password required; further validated by OTP for User role |
| OTP | Presumed numeric/short code entered on a dedicated screen; expiry/attempt-limit rules `NEEDS CLARIFICATION` |
| File upload | File Name + selected file required; type/size constraints `NEEDS CLARIFICATION` |
| Business rule: audit eligibility | A file must exist/be uploaded before an Audit Request can be created (FR-008 precondition) |

---

## 23. Error Handling Requirements

`NEEDS CLARIFICATION` across the board — no failure-path screens (invalid login, failed upload, failed proof/tamper-detected result, duplicate registration) were present among the 15 screenshots or described in the text documents. Recommended (not yet confirmed) error conditions to design for, since they are logically required by the workflow:

| Error Condition | Expected System Behavior (proposed, `NEEDS CLARIFICATION`) | User-Visible Message | Logging |
|---|---|---|---|
| Duplicate registration email | Reject registration | "Email already registered" (proposed) | `NEEDS CLARIFICATION` |
| Invalid login credentials | Reject login | "Invalid email or password" (proposed) | `NEEDS CLARIFICATION` |
| Incorrect/expired OTP | Block access, allow retry/resend | "Incorrect or expired OTP" (proposed) | `NEEDS CLARIFICATION` |
| File upload failure | Reject with retry option | "Upload failed, please try again" (proposed) | `NEEDS CLARIFICATION` |
| Audit proof indicates tampering/loss | Report failed integrity result distinctly from a successful one | "Integrity check failed for this file" (proposed) | `NEEDS CLARIFICATION` |

---

## 24. Security Requirements

- Private key issuance restricted to the KGC role, generated from a master secret key plus user attributes (biometric-derived) — NFR-001.
- Formal security goal: **soundness** under CDH and Discrete Log assumptions in the selective-ID model — NFR-002.
- File integrity protected via hash codes generated at upload — NFR-003, NFR-010.
- Password-based auth plus OTP second factor for the User role — NFR-004.
- Input validation on registration/login/upload forms — Section 22.
- `NEEDS CLARIFICATION`: injection prevention, session/token security, transport encryption (HTTPS) — none of these are documented; standard secure-development practice should be applied but is not sourced from the material, so it is **not** marked Confirmed.
- Sensitive data handling for biometric images should be treated carefully (NFR-011) even though retention/encryption policy is undocumented.

---

## 25. Technology Requirements

| Category | Confirmed | Suggested | Needs Clarification |
|---|---|---|---|
| Programming language | Java (`SYSTEM_SPECIFICATION.docx`, `Synopsis.docx`: "JAVA/J2EE") | — | Whether J2EE (full enterprise stack) or plain Java + servlets/JSP is actually used — screenshots' URLs (`*.jsp`) confirm **JSP** specifically |
| Backend | JSP-based server pages (confirmed by screenshot URLs: `User.jsp`, `KGC.jsp`, `TPA.jsp`, `Cloud.jsp`, etc.) | — | Whether any additional framework (Spring, etc.) is used — not evidenced |
| Database | MySQL (`SYSTEM_SPECIFICATION.docx`, `Synopsis.docx`) | — | `SOFTWARE_ENVIRONMENT.docx`'s "MS Access" mention conflicts — see **CONFLICT-003** |
| Frontend | Server-rendered HTML forms (per screenshots) | — | No CSS framework/library is named anywhere |
| Email delivery | Used for private-key delivery and OTP (per screenshots, e.g. Gmail shown as the recipient inbox) | — | Which mail-sending mechanism/library (e.g., JavaMail) is used server-side — not documented |
| Charting | `SOFTWARE_ENVIRONMENT.docx` describes **JFreeChart** at length | Only include if a reporting/analytics feature is actually planned | No chart/graph/report screen appears in any of the 15 screenshots — likely irrelevant boilerplate, see note below |
| Mobile | `SOFTWARE_ENVIRONMENT.docx` describes **J2ME** at length | — | No mobile screens or requirement elsewhere — likely irrelevant boilerplate |
| Networking | Java Networking / sockets described generically in `SOFTWARE_ENVIRONMENT.docx` | — | Not clearly tied to a specific project feature |

**Note on `SOFTWARE_ENVIRONMENT.docx`:** This document contains long generic sections (Java language basics, ODBC, JDBC goals, TCP/IP fundamentals, JFreeChart, J2ME) that read as a reusable "software environment" template rather than content specific to this project — none of the JFreeChart/J2ME/detailed-networking material is reflected in any other document or screenshot. This PRD treats the **JSP + MySQL + Java** facts as Confirmed (they're corroborated by `SYSTEM_SPECIFICATION.docx`, `Synopsis.docx`, and the screenshot URLs) and treats the JFreeChart/J2ME/ODBC/detailed-socket content as likely **not applicable** to this specific project, pending student confirmation.

---

## 26. Hardware and Software Requirements

### Hardware Requirements (as stated in `SYSTEM_SPECIFICATION.docx` / `Synopsis.docx`)
- System: Pentium IV 2.4 GHz
- Hard Disk: 40 GB
- Floppy Drive: 1.44 MB
- Monitor: 15" VGA Colour
- Mouse: Logitech
- RAM: 512 MB

> `NEEDS VERIFICATION`: These specifications (a Pentium IV CPU and a 1.44 MB floppy drive) describe hardware from roughly the early-to-mid 2000s and are almost certainly a **copy-pasted boilerplate template** rather than the actual development machine — the screenshots show a modern Chrome browser UI running against `localhost:8084`, which is inconsistent with such old hardware being a hard requirement. Recommend replacing with realistic current hardware (e.g., any machine capable of running a modern JDK, MySQL, and a browser) before final submission, and flagging this to the guide.

### Software Requirements (as stated)
- Operating System: Windows XP / 7 — `NEEDS VERIFICATION` (also outdated; any current OS supporting the required Java/MySQL toolchain should suffice)
- Coding Language: Java / J2EE
- Database: MySQL (see **CONFLICT-003**)

### Development Environment
`NEEDS CLARIFICATION` — no IDE, JDK version, build tool (Maven/Ant), or servlet container/app server version is specified anywhere. Screenshots show the app running on `localhost:8084`, which is consistent with a servlet container such as Apache Tomcat, but this is inferred, not confirmed.

### Runtime Environment
`NEEDS CLARIFICATION` — same as above; local/single-machine deployment is evidenced (via `localhost`), consistent with an academic demo rather than a production deployment.

---

## 27. Integration Requirements

| System | Purpose | Data Exchanged | Direction | Authentication | Failure Behavior |
|---|---|---|---|---|---|
| Email service (e.g., Gmail, per screenshot) | Deliver private keys and OTPs to users | Private key string; OTP code | Server → User's email inbox | `NEEDS CLARIFICATION` (SMTP credentials, provider) | `NEEDS CLARIFICATION` |
| Cloud storage backend | Store uploaded files | File content + metadata (name, hash, timestamp) | User → Cloud Server module | Cloud Server login | `NEEDS CLARIFICATION` |

No external third-party APIs (payment, maps, social login, etc.) are referenced anywhere in the source material.

---

## 28. AI/ML Requirements

This project does **not** require AI/ML functionality. It is a cryptographic/security protocol implementation (fuzzy identity-based encryption applied to data auditing), not a machine-learning system. The only AI-adjacent mention ("AI-Based Threat Detection for identifying anomalies and cyber-attacks in real-time") appears explicitly under **Future Enhancement** in `Synopsis.docx` Chapter 6, and is out of scope for the current build (see Section 7).

---

## 29. Reporting and Analytics

No reporting/dashboard/analytics/export screens are shown among the 15 screenshots, and none are described as a current feature in the text documents. `SOFTWARE_ENVIRONMENT.docx`'s detailed JFreeChart section is **not** corroborated by any other document — treat any chart/report feature as `NEEDS CLARIFICATION` / Future Scope, not a current requirement.

---

## 30. Notifications

| Type | Trigger | Recipient | Delivery Mechanism | Content |
|---|---|---|---|---|
| Private key issuance | KGC approves user | User | Email | Private key string (e.g., "Private Key: FUZZY160020321") |
| OTP | User attempts login | User | Email | One-time numeric/alphanumeric code |
| Registration confirmation | User submits registration form | User (in-browser) | On-screen alert dialog | "Registration successful" |

`NEEDS CLARIFICATION`: notifications for audit results (pass/fail), and whether TPA/Cloud Server receive any email notifications, are not documented.

---

## 31. Performance Requirements

No response-time, throughput, concurrent-user, or data-volume targets are specified anywhere in the source material. `NEEDS CLARIFICATION` for all of the following:
- Expected response time for login/upload/audit actions.
- Expected concurrent user count (likely small/single-digit for an academic demo, but not stated).
- Expected file size/data volume limits.
- Resource constraints beyond the outdated hardware list in Section 26 (which is itself flagged `NEEDS VERIFICATION`).

---

## 32. Constraints

- **Academic constraints:** Must be completable, demonstrable, and defensible by the student team (Kiran B C, Kishor K, Chandan Malik, Anil Kumar Parida) within the VTU 7th Semester Major Project Phase II (BCS786) timeline, under the guidance of Prof. Prashanthkumar L at R R Institute of Technology.
- **Technology constraints:** Java/JSP + MySQL stack is the confirmed baseline (Section 25); should not be replaced with unrelated technologies without reason.
- **Time constraints:** `NEEDS CLARIFICATION` — no submission deadline is provided in source material.
- **Hardware constraints:** Documented hardware list is outdated boilerplate (Section 26); real constraint is likely "any machine that can run the required Java/MySQL stack."
- **Data constraints:** No real production data; academic/demo data only (as seen in screenshots, e.g., sample user "naresh").
- **Budget constraints:** None documented; project relies on freely available technologies (`SYSTEM_STUDY.docx`, Economic Feasibility).
- **Deployment constraints:** Evidenced as local/`localhost` deployment only; no cloud hosting requirement documented.

---

## 33. Assumptions

- **A-001:** KGC, TPA, and Cloud Server accounts are single pre-provisioned/admin-style accounts rather than self-service-registered accounts, since no registration screen exists for these roles among the 15 screenshots. *(= `ASSUMPTION-001` referenced above)*
- **A-002:** The "Confirm Password" field on registration must match the "Password" field before submission succeeds.
- **A-003:** The biometric input is a single image file (e.g., a fingerprint scan saved as an image), based on the "Bio-Metric" file-chooser labeled for `.png` files in the registration screenshot, and the fingerprint-icon thumbnails shown in the KGC approval table.
- **A-004:** The system is intended purely as an academic prototype/demo (single local deployment), not a production multi-tenant service, consistent with the Abstract's own description of it as a "prototype implementation."
- **A-005:** MySQL is the correct database technology; the "MS Access" reference in `SOFTWARE_ENVIRONMENT.docx` is unreliable boilerplate (see **CONFLICT-003**).

---

## 34. Dependencies

- **Software dependencies:** Java runtime/JDK, a servlet container (inferred, e.g., Tomcat, given `localhost:8084`), MySQL database server, a mail-sending capability (for OTP/private key emails).
- **External services:** An email provider/account capable of sending mail (Gmail shown as the receiving side in screenshots; sending mechanism unconfirmed).
- **Datasets:** None — no external dataset is used; all data is user-generated (registration, uploads).
- **Hardware:** Any machine capable of running the above stack (see Section 26 caveats).
- **Other modules:** Each module (User, KGC, TPA, Cloud) depends on the others as described in Section 15's dependency column.
- **Third-party services:** None beyond email delivery.

---

## 35. Risks

| Risk ID | Risk | Probability | Impact | Mitigation |
|---|---|---|---|---|
| R-001 | Contaminated academic identity from source `.docx` files (another student's name/USN/college/guide) is not fully scrubbed from the underlying report chapters before final compilation | Medium | High | Re-run a find/replace pass over all source `.docx` files (Synopsis, etc.) to remove the other student's identity details and insert the correct team/guide/institution details from this PRD's Cover-Page section |
| R-002 | Database technology conflict (CONFLICT-003) leads to building against the wrong DB | Low–Medium | Medium | Confirm MySQL vs. MS Access explicitly before implementation begins |
| R-003 | Ambiguous "approve/reject file request" feature (CONFLICT-002) is implemented incorrectly or omitted when it was actually required | Medium | Medium | Clarify with guide whether this is a real feature; treat as Optional/Future until confirmed |
| R-004 | Missing error-handling/validation specifics leads to an incomplete or fragile demo | Medium | Medium | Design reasonable defaults (Section 23) and confirm with student before hardening |
| R-005 | Cryptographic implementation of the fuzzy identity-based scheme is non-trivial (formal pairing-based cryptography); a full from-scratch implementation may be infeasible for the demo timeline | Medium | High | Consider a simplified/simulated version of the cryptographic core for demo purposes, clearly labeled as such, while keeping the workflow (registration → approval → key → upload → audit → proof) fully functional |
| R-006 | Outdated hardware/software requirements (Section 26) misinform setup expectations | Low | Low | Update Section 26 with realistic current requirements before final documentation |

---

## 36. Requirement Traceability Matrix

| Requirement | Module | User Story | Use Case | Test Case (proposed) |
|---|---|---|---|---|
| FR-001 | MOD-01 | US-001 | UC-001 | TC-001 |
| FR-002 | MOD-02 | US-002 | UC-002 | TC-002 |
| FR-003 | MOD-02 | US-002 | UC-002 | TC-003 |
| FR-004 | MOD-01 | US-003 | UC-003 (precondition) | TC-004 |
| FR-005 | MOD-01 | US-003 | UC-003 (precondition) | TC-005 |
| FR-006 | MOD-01 / MOD-04 | US-004 | UC-003 | TC-006 |
| FR-007 | MOD-01 | US-004 | UC-003 | TC-007 |
| FR-008 | MOD-01 | US-005 | UC-004 | TC-008 |
| FR-009 | MOD-03 | US-006 | UC-004 | TC-009 |
| FR-010 | MOD-03 | US-006 | UC-004 | TC-010 |
| FR-011 | MOD-04 | US-007 | UC-004 | TC-011 |
| FR-012 | MOD-04 | — | UC-004 | TC-012 |
| FR-013 | MOD-04 | US-007 | UC-004 | TC-013 |
| FR-014 | MOD-01/03 | US-008 | UC-004 | TC-014 |
| FR-015 | MOD-02 | — | — | TC-015 |
| FR-016 | MOD-02 | — | — | TC-016 |
| FR-017 (`NEEDS CLARIFICATION`) | MOD-01 | — | — | TC-017 (deferred) |

---

## 37. Acceptance Criteria

The project should be considered complete when:
- All **Must Have** functional requirements (FR-001 through FR-014) are implemented and demonstrable end-to-end: registration → KGC approval/key issuance → login+OTP → upload → audit request → TPA relay → cloud proof → proof check result.
- The core cryptographic property — that verification tolerates small biometric variation ("error tolerance") while still detecting genuinely tampered/mismatched identities — is demonstrable in some form, even if simplified for the academic prototype (see R-005).
- Major error cases identified in Section 23 are handled in at least a basic way (even if exact messages differ from the proposed text).
- Database operations for User, PrivateKey, File, and AuditRequest/Proof entities function correctly against MySQL.
- Security requirements in Section 24 that are marked Confirmed are addressed.
- Documentation set (Introduction, Literature Survey, System Analysis, System Design, Implementation, Testing, Screenshots, Conclusion, Bibliography — i.e., the very documents already provided) is complete and consistent, with the conflicts in this PRD resolved.

---

## 38. MVP Definition

### MVP (must work for demonstration)
- FR-001 – FR-014 (registration, KGC approval + key issuance, login + OTP, file upload with hashing, my files, audit request, TPA relay, cloud server proof generation, proof check).

### Version 2 / Future Enhancement
- FR-015, FR-016 (KGC Key Request / Users tabs as separate refined views) — Should/Could Have, can ship after MVP if time-constrained.
- FR-017 — data-owner-to-user file access approval — deferred pending clarification (CONFLICT-002).
- All items in Section 7's "Future Scope" (blockchain integration, advanced biometrics, AI threat detection, multi-cloud, mobile apps, performance optimization) per `Synopsis.docx` Chapter 6.

---

## 39. Implementation Priority

| Priority | Requirements |
|---|---|
| P0 — Critical | FR-001, FR-003, FR-004, FR-005, FR-006, FR-008, FR-010, FR-013, FR-014 |
| P1 — High | FR-002, FR-007, FR-009, FR-011, FR-012 |
| P2 — Medium | FR-015, FR-016 |
| P3 — Low | FR-017 (pending clarification) |

---

## 40. Testing Requirements

- **Unit testing:** Validate individual functions — e.g., hash generation on upload, private-key derivation from attributes, OTP generation/validation logic.
- **Integration testing:** Confirm cross-module flows — e.g., KGC approval correctly triggers an email to the User module's registered address; Audit Request correctly reaches the TPA module and then the Cloud module.
- **System testing:** End-to-end run of the full normal workflow (Section 16) on the deployed system.
- **Functional testing:** Verify each FR in Section 11 against its acceptance criteria.
- **Validation testing:** Confirm registration/login/upload input validation rules (Section 22) behave as specified (where confirmed) or as reasonably designed (where marked `NEEDS CLARIFICATION`).
- **Security testing (where relevant):** Confirm that a tampered/mismatched file or a mismatched biometric identity beyond the tolerated "fuzziness" threshold correctly fails verification (soundness property, NFR-002/NFR-006).
- **User acceptance testing:** Guide/evaluator walkthrough of the full demo flow across all four roles.

Note: per the governing instructions for this PRD, no test code is written here — this section defines *what* must be tested, not the test implementation.

---

## 41. Documentation Requirements

The following documents already exist as source material and should be kept in sync with this PRD as implementation proceeds: Synopsis, Abstract, Introduction, Literature Survey, System Analysis, System Design, System Specification, System Study, Input/Output Design, Implementation, System Testing, Screenshots, Conclusion, Bibliography. Additional documentation to plan for:
- Technical documentation (architecture, module design) — largely already drafted in `SYSTEM_DESIGN.docx`.
- User documentation — not yet present; `NEEDS CLARIFICATION`/`OPTIONAL` depending on grading requirements.
- API documentation — not applicable unless an API layer is added (Section 19).
- Installation/configuration instructions — not yet present; recommend adding given the outdated Section 26 requirements need replacing.
- Project report — the combined set of provided `.docx` files effectively is this report; this PRD can guide reconciling them.
- Testing documentation — `SYSTEM_TESTING.docx` provides a starting point but records "all test cases passed" without listing the actual test cases; recommend expanding per Section 40.

---

## 42. VTU Academic Requirements

This project is a **VTU 7th Semester Major Project Work Phase II**, course/project code **BCS786**, undertaken by the student team **Kiran B C (1RI23CS067), Kishor K (1RI23CS068), Chandan Malik (1RI23CS028), and Anil Kumar Parida (1RI23CS009)** at **R R Institute of Technology**, under the guidance of **Prof. Prashanthkumar L**.

`NEEDS VERIFICATION FROM OFFICIAL VTU/DEPARTMENT GUIDELINES`: No official VTU regulation document, evaluation rubric, review schedule, credit structure, or marks-distribution scheme was provided as part of the source material. This PRD does not fabricate any such details. Before final submission, the team should independently confirm with the department:
- Phase II review dates and deliverable checklist.
- Evaluation/marks distribution and viva format.
- Report formatting requirements (VTU/department template, page limits, plagiarism thresholds, binding requirements).
- Any mandated demonstration or code-submission requirements specific to R R Institute of Technology / VTU for BCS786.

What **is** confirmed for academic presentation purposes:
- The project already has a full chaptered document set (Abstract, Introduction, Literature Survey, System Analysis, System Design, Implementation, Testing, Screenshots, Conclusion, Bibliography) consistent with a standard capstone project report structure — see Section 45 for source mapping.
- A working prototype with screenshots already exists, suggesting demonstration readiness is realistic.
- **Important:** Some of these underlying `.docx` source files (particularly `Synopsis.docx`) still contain a different student's academic identity (name, USN, guide, college, university, degree). That information is **contaminated source material from an unrelated project** and must be corrected in the source files themselves — replaced with this team's identity (Section "Cover-Page / Report Information" below) — before the report chapters are compiled for submission.

---

## 43. Open Questions

- **Q-001 (RESOLVED):** Confirmed — this is a VTU 7th Semester Major Project Phase II (BCS786) at R R Institute of Technology, team Kiran B C, Kishor K, Chandan Malik, Anil Kumar Parida, guided by Prof. Prashanthkumar L. Remaining action: scrub the contaminated identity details (another student's name/USN/college/guide) from the underlying `.docx` source files themselves.
- **Q-002:** Is MySQL or MS Access the correct database? (CONFLICT-003)
- **Q-003:** Is the "data owner approves/rejects another user's file request and emails a secret key" feature real and required, or leftover boilerplate text? (CONFLICT-002)
- **Q-004:** Are KGC, TPA, and Cloud Server truly single pre-provisioned accounts, or should they support multiple/self-registered accounts? (A-001)
- **Q-005:** What exactly is captured as "biometric" data — a fingerprint image specifically, or any biometric image? What format/size limits apply?
- **Q-006:** What are the OTP's expiry time and retry/resend rules?
- **Q-007:** What file size/type limits, if any, apply to uploads?
- **Q-008:** What should happen, precisely, when an audit reveals tampered/missing data — is there a specific failure UI, notification, or remediation flow expected?
- **Q-009:** Is any reporting/analytics/chart feature (suggested by the JFreeChart content in `SOFTWARE_ENVIRONMENT.docx`) actually in scope, or is that boilerplate irrelevant to this project?
- **Q-010:** What are the real target hardware/software/deployment environment (Section 26 content is outdated boilerplate)?
- **Q-011:** Is there a hard submission deadline or timeline constraint the implementation plan should respect?
- **Q-012:** Should the cryptographic core (fuzzy IBE-based auditing protocol) be fully implemented, or is a simplified/simulated version acceptable for the academic demo? (R-005)

---

## 44. Final Requirement Summary

- **Major modules:** 4 (User, KGC, TPA, Cloud Server)
- **Functional requirements:** 17 (FR-001–FR-017; 1 deferred pending clarification)
- **Non-functional requirements:** 11 (NFR-001–NFR-011)
- **User roles:** 4 (User, KGC, TPA, Cloud Server)
- **Major workflows:** 2 confirmed normal workflows (Registration & Key Issuance; Upload & Audit) + 2 exception workflows (Section 16)
- **MVP features:** FR-001 through FR-014 (full registration-to-proof-check pipeline)
- **Major technical dependencies:** Java/JSP, MySQL, email delivery service, servlet container (inferred)
- **Major unresolved questions:** 12 (Q-001–Q-012; Q-001 now resolved with correct academic identity), including 2 remaining formal conflicts in the technical source material (CONFLICT-002, CONFLICT-003)

---

## 45. Source-to-Requirement Mapping

| Requirement/Section | Source Document(s) | Relevant Section | Confidence |
|---|---|---|---|
| FR-001 (Registration) | `Synopsis.docx` (User module); Screenshots (registration form) | Ch. 4 Implementation; Screenshot #3 | HIGH |
| FR-002/FR-003 (KGC approval & key issuance) | `Synopsis.docx`, `IMPLEMENTATION.docx` (KGC module); Screenshots | Ch. 4; Screenshots #5, #6, #8 | HIGH |
| FR-004/FR-005 (Login + OTP) | Screenshots only (User Login, OTP Verification pages) | Screenshots #7, #8 | MEDIUM (visual only; no text description of OTP anywhere) |
| FR-006/FR-007 (Upload / My Files) | `Synopsis.docx` (User module: "upload files... with encrypted keywords and hashing algorithms"); Screenshots | Ch. 4; Screenshot #8 (File Upload) | HIGH |
| FR-008 (Audit Request) | Screenshots (Audit Request table) | Screenshot #11 | HIGH |
| FR-009/FR-010 (TPA) | `Synopsis.docx` (TPA module); Screenshots | Ch. 4; Screenshot #12 | HIGH |
| FR-011/FR-012/FR-013 (Cloud Server) | `Synopsis.docx` (Cloud Server module); Screenshots | Ch. 4; Screenshots #13, #14, #15 | HIGH |
| FR-014 (Proof Check) | Screenshots (Proof Check tab label; Send Proof/verification flow) | Screenshot #8 (tab present), #15 | MEDIUM (tab observed; internal logic not documented) |
| FR-017 / CONFLICT-002 | `IMPLEMENTATION.docx`, `Synopsis.docx` (User module text) | Ch. 4 | LOW (conflicting/unclear vs. other evidence) |
| Existing System / Problem Statement | `SYSTEM_ANALYSIS.docx` | "EXISTING SYSTEM", "DISADVANTAGES OF EXISTING SYSTEM" | HIGH |
| Proposed System / Solution | `SYSTEM_ANALYSIS.docx`, `ABSTRACT.docx`, `Synopsis.docx` | "PROPOSED SYSTEM"; full Abstract | HIGH |
| Security assumptions (CDH, Discrete Log, selective-ID) | `ABSTRACT.docx` | Full Abstract text | HIGH |
| Hardware/Software Requirements | `SYSTEM_SPECIFICATION.docx`, `Synopsis.docx` Ch. 5 | Full document | HIGH (as literally stated) / flagged NEEDS VERIFICATION for realism |
| Database = MySQL vs. MS Access | `SYSTEM_SPECIFICATION.docx`, `Synopsis.docx` vs. `SOFTWARE_ENVIRONMENT.docx` | See CONFLICT-003 | MySQL: HIGH: MS Access: LOW |
| Feasibility (Economic/Technical/Social) | `SYSTEM_STUDY.docx` | Full document | HIGH |
| Testing approach | `SYSTEM_TESTING.docx` | Full document | HIGH (as literally stated; lacks concrete test cases) |
| Input/Output Design principles | `INPUT_DESIGN_AND_OUTPUT_DESIGN.docx` | Full document | HIGH |
| Literature/related work | `LITERATURE_SURVEY.docx`, `BIBILOGRAPHY.docx` | Full documents | HIGH |
| Academic identity (degree/university/college/guide) | Team-provided correction (this PRD's Cover-Page / Report Information section) | — | HIGH (team-confirmed) — supersedes contaminated identity details found in `Synopsis.docx`'s cover page, which belong to an unrelated project |
| UI/UX details (Section 21) | Screenshots (all 15) | `SCREEN_SHOTS.docx` embedded images | HIGH (directly observed) |
| Future Scope items | `Synopsis.docx` | Ch. 6 "FUTURE ENHANCEMENT" | HIGH |

---

## Quality Check Performed

- Every Must-Have feature identified in the source material has a corresponding FR (Sections 11, 44). ✔
- Each user role has stated permissions (Section 9). ✔
- Both major workflows use only requirements already defined (Section 16 references FR-001–FR-014). ✔
- No requirement contradicts another **within this PRD**; genuine contradictions **in the technical source material** are surfaced explicitly as CONFLICT-002/003 rather than silently resolved, per governing instructions. The academic-identity conflict (formerly CONFLICT-001) has been resolved with team-confirmed information and reclassified as source-document contamination. ✔
- Module responsibilities are distinct and non-overlapping (Section 15). ✔
- Conceptual database entities support the functional requirements (Sections 17–18). ✔
- No API requirements were invented; Section 19 is explicitly marked as unconfirmed/conceptual. ✔
- Security requirements map to the user roles that need them (Section 24 ↔ Section 9). ✔
- Testing requirements (Section 40) cover all functional requirement groups. ✔
- Traceability IDs are consistent across Sections 11–13, 36, and 45. ✔
- Assumptions (Section 33) are listed separately from confirmed requirements, and every assumption is referenced by ID where used elsewhere. ✔
- Future-scope items (Section 7) are excluded from the MVP (Section 38). ✔
- No technology is presented as mandatory unless it is corroborated by at least the specification document or the screenshots (Section 25). ✔
- No invented facts are presented as confirmed; every uncertain point uses `ASSUMPTION`, `NEEDS CLARIFICATION`, `NEEDS VERIFICATION`, or `OPTIONAL` tags throughout. ✔

---

## CHANGE LOG (v1.0 → v1.1)

**Removed (previous, incorrect identity — confirmed not present anywhere in the corrected document, verified by full-text search):**
- Student name "C B Arpitha" and USN "U03DB23S0039"
- Guide "Mrs. Geetha H B"
- Institution "G.T Institute of Management Studies and Research," address "Sunkadakatte, Magadi Main Road, Bangalore-560091"
- University "Bangalore University" and degree "BCA / Bachelor of Computer Application"
- Project type "Internship Project"

**Added (correct identity):**
- Project team: Kiran B C (1RI23CS067), Kishor K (1RI23CS068), Chandan Malik (1RI23CS028), Anil Kumar Parida (1RI23CS009)
- Guide: Prof. Prashanthkumar L
- Institution: R R Institute of Technology
- New Section **1A. Cover-Page / Report Information** as the single authoritative source for academic identity

**Academic context corrected:**
- Changed from an unresolved "CONFLICT-001" between "VTU" and "Bangalore University/BCA" to a confirmed, resolved identity: **VTU 7th Semester Major Project Work Phase II, course code BCS786, R R Institute of Technology**
- Section 42 (VTU Academic Requirements) rewritten to state this identity directly; VTU-specific regulations, marks, review dates, and credits are still explicitly marked `NEEDS VERIFICATION FROM OFFICIAL VTU/DEPARTMENT GUIDELINES` since no official VTU/department document was provided — none have been fabricated
- Open Question Q-001 marked RESOLVED
- Risk R-001 reframed around scrubbing the source `.docx` files rather than around an unresolved identity conflict

**Guide corrected:** Mrs. Geetha H B → Prof. Prashanthkumar L (Section 8, Section 42, Section 1A)

**College/institution corrected:** G.T Institute of Management Studies and Research (Bangalore University) → R R Institute of Technology (VTU)

**Persona section updated:** Added an explicit note distinguishing the sample/demo application user ("Naresh," from screenshots) from the real project team, so the two are never conflated.

**Preserved unchanged (Category A — technical content):** All functional requirements (FR-001–FR-017), non-functional requirements, user roles, use cases, user stories, system modules, workflows, data/database requirements, security requirements, technology stack findings, MVP definition, priorities, testing requirements, traceability matrix, and the two remaining technical conflicts — **CONFLICT-002** (ambiguous "approve/reject file request" feature) and **CONFLICT-003** (MySQL vs. MS Access) — are unchanged from v1.0, since they concern the project's technical content, not academic identity.

**Remaining items requiring verification:**
- Scrub the other student's identity from the underlying `.docx` source files themselves (this PRD only corrects the PRD document).
- Obtain official VTU/R R Institute of Technology guidelines for BCS786 Phase II (review dates, marks distribution, report template, viva format) — currently `NEEDS VERIFICATION FROM OFFICIAL VTU/DEPARTMENT GUIDELINES`.
- CONFLICT-002 and CONFLICT-003 (technical conflicts, unrelated to identity) remain open — see Sections 7 and 18.
