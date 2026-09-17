# ==============================================================================
# test_live_vercel_deployment.ps1 - E2E Verification of Public Vercel App
# Target: https://fuzzy-identity-auditing.vercel.app
# ==============================================================================
param(
    [string]$baseUrl = "https://fuzzy-identity-auditing.vercel.app"
)

$ErrorActionPreference = 'Stop'

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "     VERIFYING LIVE PUBLIC VERCEL PRODUCTION DEPLOYMENT           " -ForegroundColor Cyan
Write-Host "     Target URL: $baseUrl" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

$passCount = 0
$failCount = 0

function Assert-Test($desc, $cond) {
    if ($cond) {
        Write-Host "  -> [PASS] $desc" -ForegroundColor Green
        $script:passCount++
    } else {
        Write-Host "  -> [FAIL] $desc" -ForegroundColor Red
        $script:failCount++
    }
}

# 1. Homepage & Static Portals
Write-Host "`n[1/11] Verifying Homepage & Portal Endpoints on Public Vercel..." -ForegroundColor Yellow
$routes = @("/", "/user", "/kgc", "/tpa", "/cloud")
foreach ($r in $routes) {
    try {
        $resp = Invoke-WebRequest -Uri "$baseUrl$r" -UseBasicParsing -TimeoutSec 15
        Assert-Test "Route $r returned HTTP $($resp.StatusCode)" ($resp.StatusCode -eq 200)
    } catch {
        Assert-Test "Route $r failed: $_" $false
    }
}

# 2. User Registration & Duplicate Prevention
Write-Host "`n[2/11] Testing User Registration & Duplicate Prevention..." -ForegroundColor Yellow
$testEmail = "live_auditor_" + (Get-Random -Minimum 1000 -Maximum 9999) + "@clouddefense.org"
$regPayload = @{
    name = "Dr. Live Researcher"
    email = $testEmail
    password = "LiveSecurePass2026!"
    phone = "+1-555-893-0192"
    bio_sign = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
} | ConvertTo-Json

try {
    $regResp = Invoke-RestMethod -Uri "$baseUrl/api/auth?action=register" -Method Post -Body $regPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Registration succeeded: $($regResp.message)" ($regResp.success -eq $true)
} catch {
    Assert-Test "Registration request failed: $_" $false
}

try {
    $dupResp = Invoke-RestMethod -Uri "$baseUrl/api/auth?action=register" -Method Post -Body $regPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Duplicate registration should have failed" $false
} catch {
    Assert-Test "Duplicate registration blocked with 409 Conflict" ($_.Exception.Response.StatusCode.value__ -eq 409)
}

# 3. Negative Login (Prior to KGC Approval)
Write-Host "`n[3/11] Testing Unapproved Login Prevention (Pre-KGC Approval)..." -ForegroundColor Yellow
$loginPayload = @{
    email = $testEmail
    password = "LiveSecurePass2026!"
} | ConvertTo-Json

try {
    $unapprovedResp = Invoke-RestMethod -Uri "$baseUrl/api/auth?action=login" -Method Post -Body $loginPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Unapproved user should not be able to login" $false
} catch {
    Assert-Test "Unapproved user blocked with 403 Forbidden (Pending KGC Approval)" ($_.Exception.Response.StatusCode.value__ -eq 403)
}

# 4. KGC Registry Lookup & Private Key Generation
Write-Host "`n[4/11] Testing KGC Authorization & Private Key Generation..." -ForegroundColor Yellow
try {
    $kgcList = Invoke-RestMethod -Uri "$baseUrl/api/kgc?action=list" -Method Get -TimeoutSec 15
    $targetUser = $kgcList.users | Where-Object { $_.email -eq $testEmail }
    Assert-Test "Discovered pending user in KGC Registry (ID: $($targetUser.id))" ($null -ne $targetUser)

    $approvePayload = @{ userId = $targetUser.id } | ConvertTo-Json
    $approveResp = Invoke-RestMethod -Uri "$baseUrl/api/kgc?action=approve" -Method Post -Body $approvePayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "KGC Generated Master Identity Key: $($approveResp.issuedKey)" ($approveResp.success -eq $true -and $approveResp.issuedKey -like "FUZZY*")
} catch {
    Assert-Test "KGC Workflow failed: $_" $false
}

# 5. User Login & 2FA OTP Challenge
Write-Host "`n[5/11] Testing Authentication & Dynamic OTP Verification..." -ForegroundColor Yellow
try {
    $authResp = Invoke-RestMethod -Uri "$baseUrl/api/auth?action=login" -Method Post -Body $loginPayload -ContentType "application/json" -TimeoutSec 15
    $otp = $authResp.otpDemoHint
    Assert-Test "Credentials authenticated. 2FA OTP Generated: $otp" ($authResp.success -eq $true -and $null -ne $otp)

    # Bad OTP test
    try {
        $badOtpPayload = @{ email = $testEmail; otp = "000000" } | ConvertTo-Json
        Invoke-RestMethod -Uri "$baseUrl/api/auth?action=otp" -Method Post -Body $badOtpPayload -ContentType "application/json" -TimeoutSec 15
        Assert-Test "Bad OTP should have been rejected" $false
    } catch {
        Assert-Test "Bad OTP rejected with 401 Unauthorized" ($_.Exception.Response.StatusCode.value__ -eq 401)
    }

    # Valid OTP
    $validOtpPayload = @{ email = $testEmail; otp = $otp } | ConvertTo-Json
    $validOtpResp = Invoke-RestMethod -Uri "$baseUrl/api/auth?action=otp" -Method Post -Body $validOtpPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "2FA OTP Verified. Session Authorized: $($validOtpResp.user.name)" ($validOtpResp.success -eq $true)
} catch {
    Assert-Test "Login/OTP flow failed: $_" $false
}

# 6. File Upload with AES-128 Encryption & Deterministic Hash
Write-Host "`n[6/11] Testing Document Upload with AES-128 Encryption & Hash Calculation..." -ForegroundColor Yellow
$testContent = "Fuzzy Identity-Based Auditing Live Vercel Production Validation Payload #$(Get-Random)"
$filePayload = @{
    fname = "LiveVercelAuditTest_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    data = $testContent
    uid = $targetUser.id
} | ConvertTo-Json

try {
    $fileResp = Invoke-RestMethod -Uri "$baseUrl/api/files" -Method Post -Body $filePayload -ContentType "application/json" -TimeoutSec 15
    $fileKey = $fileResp.fileKey
    $origHash = $fileResp.hashCode
    Assert-Test "File Uploaded & Encrypted (AES-128 Key: $fileKey, Hash: $origHash)" ($fileResp.success -eq $true -and $null -ne $fileKey -and $null -ne $origHash)
} catch {
    Assert-Test "File upload failed: $_" $false
}

# 7. Audit Request by Data Owner
Write-Host "`n[7/11] Testing Data Owner Audit Request Dispatch..." -ForegroundColor Yellow
$auditPayload = @{
    filekey = $fileKey
    uid = $targetUser.id
} | ConvertTo-Json

try {
    $auditResp = Invoke-RestMethod -Uri "$baseUrl/api/audit?action=request" -Method Post -Body $auditPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Audit Challenge dispatched to TPA queue for key $fileKey" ($auditResp.success -eq $true)
} catch {
    Assert-Test "Audit request failed: $_" $false
}

# 8. TPA Challenge Forwarding to Cloud Server
Write-Host "`n[8/11] Testing TPA Challenge Forwarding to Cloud Storage Server..." -ForegroundColor Yellow
try {
    $tpaChallengeResp = Invoke-RestMethod -Uri "$baseUrl/api/tpa?action=challenge" -Method Post -Body $auditPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "TPA challenge forwarded to Cloud Storage Server" ($tpaChallengeResp.success -eq $true)
} catch {
    Assert-Test "TPA challenge failed: $_" $false
}

# 9. Cloud Server Computes Cryptographic Proof
Write-Host "`n[9/11] Testing Cloud Server Cryptographic Proof Computation..." -ForegroundColor Yellow
try {
    $cloudProofResp = Invoke-RestMethod -Uri "$baseUrl/api/cloud?action=proof" -Method Post -Body $auditPayload -ContentType "application/json" -TimeoutSec 15
    $proofHash = $cloudProofResp.proofHash
    Assert-Test "Cloud computed cryptographic proof: $proofHash" ($cloudProofResp.success -eq $true -and $null -ne $proofHash)
} catch {
    Assert-Test "Cloud proof computation failed: $_" $false
}

# 10. TPA Proof Verification (Positive Verification)
Write-Host "`n[10/11] Testing Positive Proof Verification (Unmodified Integrity)..." -ForegroundColor Yellow
$verifyPayload = @{
    filekey = $fileKey
    cloudProofHash = $proofHash
} | ConvertTo-Json

try {
    $verifyResp = Invoke-RestMethod -Uri "$baseUrl/api/tpa?action=verify" -Method Post -Body $verifyPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "TPA Verified: Proof matches original document hash 100%!" ($verifyResp.verified -eq $true)
} catch {
    Assert-Test "Positive verification failed: $_" $false
}

# 11. Deliberate Tampering Detection & Clean State Restoration
Write-Host "`n[11/11] Testing Deliberate Cloud Data Tampering & Negative Detection..." -ForegroundColor Yellow
try {
    # Malicious corruption
    $tamperPayload = @{
        filekey = $fileKey
        corruptedHash = "MALICIOUS_CORRUPTED_HASH_0xDEADBEEF"
    } | ConvertTo-Json
    $corruptResp = Invoke-RestMethod -Uri "$baseUrl/api/tamper?action=corrupt" -Method Post -Body $tamperPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Simulated deliberate hash corruption in Cloud Storage" ($corruptResp.success -eq $true)

    # TPA verification of tampered block
    $tamperedVerifyResp = Invoke-RestMethod -Uri "$baseUrl/api/tpa?action=verify" -Method Post -Body $verifyPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "TPA successfully detected INTEGRITY BREACH / Tampering!" ($tamperedVerifyResp.verified -eq $false -and $tamperedVerifyResp.message -like "*INTEGRITY BREACH*")

    # Clean state restoration
    $restorePayload = @{
        filekey = $fileKey
        originalHash = $origHash
    } | ConvertTo-Json
    $restoreResp = Invoke-RestMethod -Uri "$baseUrl/api/tamper?action=restore" -Method Post -Body $restorePayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "Restored clean hash state in Cloud Storage" ($restoreResp.success -eq $true)

    # Verify clean state restored
    $restoredVerifyResp = Invoke-RestMethod -Uri "$baseUrl/api/tpa?action=verify" -Method Post -Body $verifyPayload -ContentType "application/json" -TimeoutSec 15
    Assert-Test "TPA re-verified restored state: Storage integrity restored 100%!" ($restoredVerifyResp.verified -eq $true)
} catch {
    Assert-Test "Tampering test failed: $_" $false
}

Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "                PUBLIC VERCEL TEST SUITE SUMMARY                  " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Total Tests Run: $($passCount + $failCount)" -ForegroundColor White
Write-Host "  Passed:          $passCount" -ForegroundColor Green
Write-Host "  Failed:          $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host "==================================================================" -ForegroundColor Cyan

if ($failCount -gt 0) {
    exit 1
} else {
    exit 0
}
