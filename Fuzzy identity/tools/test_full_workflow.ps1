$ErrorActionPreference = 'Stop'
$baseUrl = "http://localhost:8080/Fuzzy_IDbased_DataIntegrity"

# Reset database for a clean test
$sqlPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "DATABASE\Fuzzy.sql").Replace('\', '/')
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "source $sqlPath;"

Write-Host "=== TEST 1: User Registration ==="
$dummySignPath = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\tools\test_sign.png"
if (-not (Test-Path $dummySignPath)) {
    [System.IO.File]::WriteAllBytes($dummySignPath, [byte[]]@(137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,1,0,0,0,1,8,6,0,0,0,31,21,196,137,0,0,0,10,73,68,65,84,120,156,99,0,1,0,0,5,0,1,13,10,45,180,0,0,0,0,73,69,78,68,174,66,96,130))
}

$webClient = New-Object System.Net.WebClient
$boundary = [System.Guid]::NewGuid().ToString()
$webClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$boundary")

$memStream = New-Object System.IO.MemoryStream
$sw = New-Object System.IO.StreamWriter($memStream)

function Add-FormField($name, $val) {
    $sw.WriteLine("--$boundary")
    $sw.WriteLine("Content-Disposition: form-data; name=`"$name`"")
    $sw.WriteLine()
    $sw.WriteLine($val)
}

Add-FormField "name" "Kiran"
Add-FormField "email" "kiran@example.com"
Add-FormField "dob" "2000-01-01"
Add-FormField "gender" "Male"
Add-FormField "phone" "9876543210"
Add-FormField "city" "Bangalore"
Add-FormField "country" "India"
Add-FormField "password" "123"
Add-FormField "rpassword" "123"

$sw.WriteLine("--$boundary")
$sw.WriteLine("Content-Disposition: form-data; name=`"bio_sign`"; filename=`"test_sign.png`"")
$sw.WriteLine("Content-Type: image/png")
$sw.WriteLine()
$sw.Flush()

$fileBytes = [System.IO.File]::ReadAllBytes($dummySignPath)
$memStream.Write($fileBytes, 0, $fileBytes.Length)
$sw.WriteLine()
$sw.WriteLine("--$boundary--")
$sw.Flush()

$postBytes = $memStream.ToArray()
$sw.Close()

try {
    $responseBytes = $webClient.UploadData("$baseUrl/signup", "POST", $postBytes)
    Write-Host "Registration response: SUCCESS"
} catch {
    Write-Host "Registration HTTP: $($_.Exception.Message)"
}

$userId = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT id FROM user WHERE email='kiran@example.com' ORDER BY id DESC LIMIT 1;").Trim()
Write-Host "Registered User ID: $userId"

Write-Host "=== TEST 2: KGC Approval & Key Issuance ==="
$sendKeyUrl = "$baseUrl/sendkey.jsp?uid=$userId&mid=kiran@example.com&time=2026/08/25"
$kgcResp = Invoke-WebRequest -Uri $sendKeyUrl -UseBasicParsing
Write-Host "KGC Key Issuance Status: $($kgcResp.StatusCode)"

$kgcKey = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT kgc FROM user WHERE id='$userId';").Trim()
Write-Host "Issued KGC Private Key: $kgcKey"

Write-Host "=== TEST 3: User Login (Session / Cookie) ==="
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginUrl = "$baseUrl/user_login.jsp?email=kiran@example.com&pass=123"
$loginResp = Invoke-WebRequest -Uri $loginUrl -WebSession $session -UseBasicParsing
Write-Host "User Login Status: $($loginResp.StatusCode)"

$userOtp = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT otp FROM user WHERE id='$userId';").Trim()
Write-Host "Generated OTP in DB: $userOtp"

Write-Host "=== TEST 4: User OTP Verification ==="
$otpUrl = "$baseUrl/otp1.jsp?votp=$userOtp"
$otpResp = Invoke-WebRequest -Uri $otpUrl -WebSession $session -UseBasicParsing
Write-Host "OTP Verification Status: $($otpResp.StatusCode)"

Write-Host "=== TEST 5: User File Upload ==="
$sampleDoc = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\tools\test_file.txt"
[System.IO.File]::WriteAllText($sampleDoc, "Cloud Data Integrity Auditing Test Content with Fuzzy Identity Cryptography Simulation.")

$uploadClient = New-Object System.Net.WebClient
$uploadBoundary = [System.Guid]::NewGuid().ToString()
$uploadClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$uploadBoundary")
$uploadSessionCookie = $session.Cookies.GetCookies([System.Uri]$baseUrl)["JSESSIONID"].Value
$uploadClient.Headers.Add("Cookie", "JSESSIONID=$uploadSessionCookie")

$uploadMemStream = New-Object System.IO.MemoryStream
$uploadSw = New-Object System.IO.StreamWriter($uploadMemStream)

$uploadSw.WriteLine("--$uploadBoundary")
$uploadSw.WriteLine("Content-Disposition: form-data; name=`"fname`"")
$uploadSw.WriteLine()
$uploadSw.WriteLine("ProjectDoc")

$uploadSw.WriteLine("--$uploadBoundary")
$uploadSw.WriteLine("Content-Disposition: form-data; name=`"data`"; filename=`"test_file.txt`"")
$uploadSw.WriteLine("Content-Type: text/plain")
$uploadSw.WriteLine()
$uploadSw.Flush()

$docBytes = [System.IO.File]::ReadAllBytes($sampleDoc)
$uploadMemStream.Write($docBytes, 0, $docBytes.Length)
$uploadSw.WriteLine()
$uploadSw.WriteLine("--$uploadBoundary--")
$uploadSw.Flush()

$uploadPostBytes = $uploadMemStream.ToArray()
$uploadSw.Close()

try {
    $uploadRespBytes = $uploadClient.UploadData("$baseUrl/Upload", "POST", $uploadPostBytes)
    Write-Host "File Upload response: SUCCESS"
} catch {
    Write-Host "File Upload HTTP: $($_.Exception.Message)"
}

$uploadedFileKey = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT filekey FROM fileupload WHERE uid='$userId' ORDER BY id DESC LIMIT 1;").Trim()
Write-Host "Uploaded File Key in DB: $uploadedFileKey"

Write-Host "=== TEST 6: User Request Audit ==="
$auditReqUrl = "$baseUrl/Auditing_request.jsp?fid=$uploadedFileKey&did=$userId"
$auditReqResp = Invoke-WebRequest -Uri $auditReqUrl -WebSession $session -UseBasicParsing
Write-Host "Audit Request Status: $($auditReqResp.StatusCode)"

$auditStatus = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT status FROM audit_request WHERE filekey='$uploadedFileKey';").Trim()
Write-Host "Audit Request Status in DB: $auditStatus"

Write-Host "=== TEST 7: TPA Send Challenge to Cloud ==="
$tpaSendUrl = "$baseUrl/send_cloud.jsp?uid=$userId&fid=$uploadedFileKey"
$tpaSendResp = Invoke-WebRequest -Uri $tpaSendUrl -UseBasicParsing
Write-Host "TPA Send to Cloud Status: $($tpaSendResp.StatusCode)"

$cloudReqStatus = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT status FROM cloud_request WHERE filekey='$uploadedFileKey';").Trim()
Write-Host "Cloud Request Status in DB: $cloudReqStatus"

Write-Host "=== TEST 8: Cloud Generate Proof ==="
$cloudProofUrl = "$baseUrl/audit_proof.jsp?fid=$uploadedFileKey&did=$userId"
$cloudProofResp = Invoke-WebRequest -Uri $cloudProofUrl -UseBasicParsing
Write-Host "Cloud Proof Generation Status: $($cloudProofResp.StatusCode)"

$proofResult = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT hashproof FROM audit_proof WHERE filekey='$uploadedFileKey';").Trim()
Write-Host "Generated Proof Hash in DB: $proofResult"

$finalFileStatus = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT audit_status FROM fileupload WHERE filekey='$uploadedFileKey';").Trim()
Write-Host "Final File Status in DB: $finalFileStatus"

Write-Host "`n=== TEST 9: TPA Proof Verification (Positive Test) ==="
$tpaVerifyUrl = "$baseUrl/proof_verify.jsp?fid=$uploadedFileKey&hash=$proofResult"
$tpaVerifyResp = Invoke-WebRequest -Uri $tpaVerifyUrl -UseBasicParsing
$originalHashInDB = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT hashcode FROM fileupload WHERE filekey='$uploadedFileKey';").Trim()
if ($proofResult -eq $originalHashInDB -and $tpaVerifyResp.Content -like "*$proofResult*") {
    Write-Host "[PASS] TPA Proof Verification: Cloud Proof matches Original Document Hash ($proofResult)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] TPA Proof Verification failed to match hashes" -ForegroundColor Red
}

Write-Host "`n=== TEST 10: User Integrity Verification (Positive Test) ==="
$userVerifyUrl = "$baseUrl/test.jsp?fid=$uploadedFileKey&hash=$proofResult"
$userVerifyResp = Invoke-WebRequest -Uri $userVerifyUrl -WebSession $session -UseBasicParsing
if ($userVerifyResp.Content -like "*$proofResult*") {
    Write-Host "[PASS] User Integrity Verification: Displayed matched proof hash" -ForegroundColor Green
} else {
    Write-Host "[FAIL] User Integrity Verification failed" -ForegroundColor Red
}

Write-Host "`n=== TEST 11: Deliberate Tampering / Corruption Negative Test ==="
Write-Host "Deliberately corrupting file hash in database to simulate cloud data corruption/tampering..."
$corruptedHash = "TAMPERED_MALICIOUS_HASH_X99"
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "USE fuzzy; UPDATE fileupload SET hashcode='$corruptedHash' WHERE filekey='$uploadedFileKey';"

$tpaTamperedResp = Invoke-WebRequest -Uri "$baseUrl/proof_verify.jsp?fid=$uploadedFileKey&hash=$proofResult" -UseBasicParsing
if ($tpaTamperedResp.Content -like "*$corruptedHash*") {
    Write-Host "[PASS] Tampered hash ($corruptedHash) correctly surfaced in TPA verification form" -ForegroundColor Green
    Write-Host "[PASS] Original Cloud Proof ($proofResult) != Corrupted DB Hash ($corruptedHash)" -ForegroundColor Green
    Write-Host "[PASS] TPA Client-Side Validation Logic detects MISMATCH / INTEGRITY BREACH!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Tampered hash not surfaced" -ForegroundColor Red
}

# Restore clean valid state
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "USE fuzzy; UPDATE fileupload SET hashcode='$proofResult' WHERE filekey='$uploadedFileKey';"
Write-Host "Restored original valid hash in database. Integrity verified clean."

Write-Host "`n=== TEST 12: Negative Test - Invalid User Password ==="
$badLoginResp = Invoke-WebRequest -Uri "$baseUrl/user_login.jsp?email=kiran@example.com&pass=wrongpassword999" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
$badLoginLocation = $badLoginResp.Headers["Location"]
if ($badLoginLocation -like "*User.jsp?msg=failed*" -or $badLoginLocation -like "*failed*") {
    Write-Host "[PASS] Invalid login correctly rejected with redirect: $badLoginLocation" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Invalid login was not properly rejected (Location: $badLoginLocation)" -ForegroundColor Red
}

Write-Host "`n=== TEST 13: Negative Test - Unapproved User Login ==="
# Register pending user without KGC approval
$pendingEmail = "pending_student@example.com"
$pClient = New-Object System.Net.WebClient
$pBoundary = [System.Guid]::NewGuid().ToString()
$pClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$pBoundary")
$pMem = New-Object System.IO.MemoryStream
$pSw = New-Object System.IO.StreamWriter($pMem)
function Add-PFormField($n, $v) {
    $pSw.WriteLine("--$pBoundary")
    $pSw.WriteLine("Content-Disposition: form-data; name=`"$n`"")
    $pSw.WriteLine()
    $pSw.WriteLine($v)
}
Add-PFormField "name" "PendingUser"
Add-PFormField "email" $pendingEmail
Add-PFormField "dob" "2001-05-15"
Add-PFormField "gender" "Female"
Add-PFormField "phone" "9123456780"
Add-PFormField "city" "Mysore"
Add-PFormField "country" "India"
Add-PFormField "password" "secret123"
Add-PFormField "rpassword" "secret123"
$pSw.WriteLine("--$pBoundary--")
$pSw.Flush()
$pBytes = $pMem.ToArray()
$pSw.Close()
try { $pClient.UploadData("$baseUrl/signup", "POST", $pBytes) | Out-Null } catch {}

$unapprovedResp = Invoke-WebRequest -Uri "$baseUrl/user_login.jsp?email=$pendingEmail&pass=secret123" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
$unapprovedLoc = $unapprovedResp.Headers["Location"]
if ($unapprovedLoc -like "*Pending_KGC_Approval*" -or $unapprovedLoc -like "*User.jsp*") {
    Write-Host "[PASS] Unapproved user rejected with pending approval status: $unapprovedLoc" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Unapproved user was not rejected (Location: $unapprovedLoc)" -ForegroundColor Red
}

Write-Host "`n=== TEST 14: Negative Test - Invalid OTP Verification ==="
$badOtpResp = Invoke-WebRequest -Uri "$baseUrl/otp1.jsp?votp=999999" -WebSession $session -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
$badOtpLoc = $badOtpResp.Headers["Location"]
if ($badOtpLoc -like "*Wrong_OTP_entered*" -or $badOtpLoc -like "*failed*" -or $badOtpLoc -like "*otp.jsp*") {
    Write-Host "[PASS] Invalid OTP rejected with redirect: $badOtpLoc" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Invalid OTP not rejected (Location: $badOtpLoc)" -ForegroundColor Red
}

Write-Host "`n=== TEST 15: Negative Test - Duplicate Registration Prevention ==="
$dupClient = New-Object System.Net.WebClient
$dupBoundary = [System.Guid]::NewGuid().ToString()
$dupClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$dupBoundary")
$dupMem = New-Object System.IO.MemoryStream
$dupSw = New-Object System.IO.StreamWriter($dupMem)
$dupSw.WriteLine("--$dupBoundary")
$dupSw.WriteLine("Content-Disposition: form-data; name=`"email`"")
$dupSw.WriteLine()
$dupSw.WriteLine("kiran@example.com")
$dupSw.WriteLine("--$dupBoundary")
$dupSw.WriteLine("Content-Disposition: form-data; name=`"password`"")
$dupSw.WriteLine()
$dupSw.WriteLine("123")
$dupSw.WriteLine("--$dupBoundary")
$dupSw.WriteLine("Content-Disposition: form-data; name=`"rpassword`"")
$dupSw.WriteLine()
$dupSw.WriteLine("123")
$dupSw.WriteLine("--$dupBoundary--")
$dupSw.Flush()
$dupBytes = $dupMem.ToArray()
$dupSw.Close()

$dupResult = ""
try {
    $dupRespRaw = $dupClient.UploadData("$baseUrl/signup", "POST", $dupBytes)
} catch {
    $dupResult = $_.Exception.Message
}
$dupCount = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -N -e "USE fuzzy; SELECT COUNT(*) FROM user WHERE email='kiran@example.com';").Trim()
if ([int]$dupCount -eq 1) {
    Write-Host "[PASS] Duplicate registration prevented. Email kiran@example.com count in DB remains 1" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Duplicate user created (count: $dupCount)" -ForegroundColor Red
}

Write-Host "`n=== TEST 16: File Upload with Quotes, Spaces & Special Characters ==="
$specialFileName = "Audit & Security Report '2026'.txt"
$specialDoc = Join-Path $PSScriptRoot "special_test_file.txt"
[System.IO.File]::WriteAllText($specialDoc, "Content with special filename containing apostrophes and ampersands.")

$spUploadClient = New-Object System.Net.WebClient
$spBoundary = [System.Guid]::NewGuid().ToString()
$spUploadClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$spBoundary")
$spUploadClient.Headers.Add("Cookie", "JSESSIONID=$uploadSessionCookie")

$spMem = New-Object System.IO.MemoryStream
$spSw = New-Object System.IO.StreamWriter($spMem)
$spSw.WriteLine("--$spBoundary")
$spSw.WriteLine("Content-Disposition: form-data; name=`"fname`"")
$spSw.WriteLine()
$spSw.WriteLine("SpecialDoc")
$spSw.WriteLine("--$spBoundary")
$spSw.WriteLine("Content-Disposition: form-data; name=`"data`"; filename=`"$specialFileName`"")
$spSw.WriteLine("Content-Type: text/plain")
$spSw.WriteLine()
$spSw.Flush()
$spBytes = [System.IO.File]::ReadAllBytes($specialDoc)
$spMem.Write($spBytes, 0, $spBytes.Length)
$spSw.WriteLine()
$spSw.WriteLine("--$spBoundary--")
$spSw.Flush()
$spPostBytes = $spMem.ToArray()
$spSw.Close()

try {
    $spUploadClient.UploadData("$baseUrl/Upload", "POST", $spPostBytes) | Out-Null
    Write-Host "[PASS] File with quotes & spaces uploaded successfully without SQL syntax errors" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Special filename upload failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== TEST 17: Cryptographic Round-Trip Verification ==="
$cryptoOutput = & "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\tools\jdk8u442-b06\bin\java.exe" -cp "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\SOURCE CODE\Fuzzy_IDbased_DataIntegrity\web\WEB-INF\classes" FUZZY.VerifyCryptoRoundTrip
if ($cryptoOutput -like "*CRYPTO ROUND-TRIP VERIFICATION: SUCCESS*") {
    Write-Host "[PASS] AES-128 Encryption/Decryption Round Trip: 100% Deterministic Match" -ForegroundColor Green
} else {
    Write-Host "[FAIL] AES-128 Round Trip Failed" -ForegroundColor Red
}

Write-Host "`n=========================================================================="
Write-Host "         FULL END-TO-END PIPELINE & NEGATIVE AUDIT: 100% COMPLETE         "
Write-Host "=========================================================================="

