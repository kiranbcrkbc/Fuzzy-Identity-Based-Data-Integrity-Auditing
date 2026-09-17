$baseUrl = "http://localhost:8080/Fuzzy_IDbased_DataIntegrity"
$pages = @(
    "index.jsp",
    "User.jsp",
    "User_reg.jsp",
    "user_signup.jsp",
    "otp.jsp",
    "User_home.jsp",
    "File_Upload.jsp",
    "MyFiles.jsp",
    "audit_request.jsp",
    "user_check.jsp",
    "KGC.jsp",
    "KGC_home.jsp",
    "keyreq.jsp",
    "kgc_users.jsp",
    "kgc_request.jsp",
    "kgc_idreq.jsp",
    "TPA.jsp",
    "TPA_home.jsp",
    "TPA_audit_request.jsp",
    "cloud_req.jsp",
    "proof_Check.jsp",
    "proof_verify.jsp",
    "proof.jsp",
    "Cloud.jsp",
    "cloud_home.jsp",
    "cloud_audit.jsp",
    "All_files.jsp",
    "test.jsp"
)

Write-Host "========================================="
Write-Host "   COMPREHENSIVE ENDPOINT AUDIT REPORT   "
Write-Host "========================================="

$allPassed = $true
foreach ($page in $pages) {
    try {
        $resp = Invoke-WebRequest -Uri "$baseUrl/$page" -UseBasicParsing -TimeoutSec 5
        Write-Host "[OK 200]  $page" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL]    $page -> $($_.Exception.Message)" -ForegroundColor Red
        $allPassed = $false
    }
}

if ($allPassed) {
    Write-Host "`nALL $( $pages.Count ) APPLICATION PAGES AND PORTALS RESPONDING 200 OK!" -ForegroundColor Green
} else {
    Write-Host "`nSOME ENDPOINTS FAILED!" -ForegroundColor Red
}
