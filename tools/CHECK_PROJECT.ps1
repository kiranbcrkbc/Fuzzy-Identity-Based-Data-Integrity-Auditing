# ==============================================================================
# CHECK_PROJECT.ps1 - Reviewer Pre-Flight & Demo Readiness Verification Script
# ==============================================================================
$ErrorActionPreference = 'Continue'

function Resolve-ProjectBase {
    $candidates = @(
        "$PSScriptRoot\..\Fuzzy identity",
        "$PSScriptRoot\..",
        "$PSScriptRoot",
        "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity",
        "c:\Users\a\OneDrive\Desktop\FUZZY"
    )
    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c "SOURCE CODE\Fuzzy_IDbased_DataIntegrity\web")) {
            return (Resolve-Path $c).Path
        }
    }
    return "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity"
}

$projectBase = Resolve-ProjectBase
$sourceCodeDir = Join-Path $projectBase "SOURCE CODE\Fuzzy_IDbased_DataIntegrity"
$webDir = Join-Path $sourceCodeDir "web"
$toolsDir = Join-Path $projectBase "tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$javaExe = Join-Path $jdkDir "bin\java.exe"
$javacExe = Join-Path $jdkDir "bin\javac.exe"
$mysqlExe = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$baseUrl = "http://localhost:8080/Fuzzy_IDbased_DataIntegrity"

$failedComponents = @()

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  FUZZY PROJECT REVIEW READINESS CHECK    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Java available
$javaOk = $false
try {
    if (Test-Path $javaExe) {
        $jVer = & $javaExe -version 2>&1 | Out-String
        if ($jVer -match "version") { $javaOk = $true }
    } else {
        $jVer = & java -version 2>&1 | Out-String
        if ($jVer -match "version") { $javaOk = $true }
    }
} catch {
    $javaOk = $false
}

if ($javaOk) {
    Write-Host "[PASS] Java available" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Java available" -ForegroundColor Red
    $failedComponents += "Java runtime environment"
}

# 2. MySQL running
$mysqlOk = $false
$mysqlPortOk = Test-NetConnection -ComputerName localhost -Port 3306 -InformationLevel Quiet -WarningAction SilentlyContinue
$mysqlService = Get-Service -Name *mysql* -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Running' }
if ($mysqlPortOk -or $mysqlService) {
    $mysqlOk = $true
    Write-Host "[PASS] MySQL running" -ForegroundColor Green
} else {
    Write-Host "[FAIL] MySQL running" -ForegroundColor Red
    $failedComponents += "MySQL server service / Port 3306"
}

# 3. Database fuzzy exists
$dbExists = $false
if (Test-Path $mysqlExe) {
    try {
        $dbs = & $mysqlExe -u root -proot -N -e "SHOW DATABASES LIKE 'fuzzy';" 2>$null
        if ($dbs -and $dbs.Trim() -eq 'fuzzy') {
            $dbExists = $true
        }
    } catch {
        $dbExists = $false
    }
} else {
    try {
        $dbs = & mysql -u root -proot -N -e "SHOW DATABASES LIKE 'fuzzy';" 2>$null
        if ($dbs -and $dbs.Trim() -eq 'fuzzy') {
            $dbExists = $true
        }
    } catch {}
}

if ($dbExists) {
    Write-Host "[PASS] Database fuzzy exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Database fuzzy exists" -ForegroundColor Red
    $failedComponents += "Database 'fuzzy' not found in MySQL"
}

# 4. Required database tables exist
$tablesOk = $false
$reqTables = @("audit_proof", "audit_request", "cloud_request", "fileupload", "user")
$foundTables = @()
if ($dbExists) {
    try {
        $mCmd = if (Test-Path $mysqlExe) { $mysqlExe } else { "mysql" }
        $tList = & $mCmd -u root -proot -N -e "USE fuzzy; SHOW TABLES;" 2>$null
        foreach ($t in $reqTables) {
            if ($tList -match "(?m)^$t$") {
                $foundTables += $t
            }
        }
        if ($foundTables.Count -eq $reqTables.Count) {
            $tablesOk = $true
        }
    } catch {}
}

if ($tablesOk) {
    Write-Host "[PASS] Required database tables exist" -ForegroundColor Green
} else {
    $missing = $reqTables | Where-Object { $_ -notin $foundTables }
    Write-Host "[FAIL] Required database tables exist" -ForegroundColor Red
    $failedComponents += "Missing database tables: $($missing -join ', ')"
}

# 5. JDBC connection works
$jdbcOk = $false
try {
    $libDir = Join-Path $webDir "WEB-INF\lib"
    $cpList = (Get-ChildItem -Path (Join-Path $libDir "*.jar") -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    $cp = ($cpList -join ";") + ";" + $toolsDir
    if (Test-Path (Join-Path $toolsDir "TestDB.class")) {
        $jOut = & $javaExe -cp $cp TestDB 2>&1 | Out-String
        if ($jOut -match "SUCCESS") {
            $jdbcOk = $true
        }
    } else {
        & $javacExe -cp $cp (Join-Path $toolsDir "TestDB.java")
        $jOut = & $javaExe -cp $cp TestDB 2>&1 | Out-String
        if ($jOut -match "SUCCESS") {
            $jdbcOk = $true
        }
    }
} catch {
    $jdbcOk = $false
}

if ($jdbcOk) {
    Write-Host "[PASS] JDBC connection works" -ForegroundColor Green
} else {
    Write-Host "[FAIL] JDBC connection works" -ForegroundColor Red
    $failedComponents += "JDBC database connection test"
}

# 6. Tomcat running
$tomcatOk = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($tomcatOk) {
    Write-Host "[PASS] Tomcat running" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Tomcat running" -ForegroundColor Red
    $failedComponents += "Apache Tomcat server on port 8080"
}

# 7. Application deployed
$appDeployed = $false
try {
    $resp = Invoke-WebRequest -Uri "$baseUrl/index.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($resp.StatusCode -eq 200) {
        $appDeployed = $true
    }
} catch {}

if ($appDeployed) {
    Write-Host "[PASS] Application deployed" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Application deployed" -ForegroundColor Red
    $failedComponents += "Application context /Fuzzy_IDbased_DataIntegrity"
}

# 8. Main page accessible
$mainPageOk = $false
try {
    $r = Invoke-WebRequest -Uri "$baseUrl/index.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $mainPageOk = $true }
} catch {}

if ($mainPageOk) {
    Write-Host "[PASS] Main page accessible" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Main page accessible" -ForegroundColor Red
    $failedComponents += "Main landing page (index.jsp)"
}

# 9. User portal accessible
$userPortalOk = $false
try {
    $r = Invoke-WebRequest -Uri "$baseUrl/User.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $userPortalOk = $true }
} catch {}

if ($userPortalOk) {
    Write-Host "[PASS] User portal accessible" -ForegroundColor Green
} else {
    Write-Host "[FAIL] User portal accessible" -ForegroundColor Red
    $failedComponents += "User portal (User.jsp)"
}

# 10. KGC portal accessible
$kgcPortalOk = $false
try {
    $r = Invoke-WebRequest -Uri "$baseUrl/KGC.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $kgcPortalOk = $true }
} catch {}

if ($kgcPortalOk) {
    Write-Host "[PASS] KGC portal accessible" -ForegroundColor Green
} else {
    Write-Host "[FAIL] KGC portal accessible" -ForegroundColor Red
    $failedComponents += "KGC portal (KGC.jsp)"
}

# 11. TPA portal accessible
$tpaPortalOk = $false
try {
    $r = Invoke-WebRequest -Uri "$baseUrl/TPA.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $tpaPortalOk = $true }
} catch {}

if ($tpaPortalOk) {
    Write-Host "[PASS] TPA portal accessible" -ForegroundColor Green
} else {
    Write-Host "[FAIL] TPA portal accessible" -ForegroundColor Red
    $failedComponents += "TPA portal (TPA.jsp)"
}

# 12. Cloud portal accessible
$cloudPortalOk = $false
try {
    $r = Invoke-WebRequest -Uri "$baseUrl/Cloud.jsp" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $cloudPortalOk = $true }
} catch {}

if ($cloudPortalOk) {
    Write-Host "[PASS] Cloud portal accessible" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Cloud portal accessible" -ForegroundColor Red
    $failedComponents += "Cloud portal (Cloud.jsp)"
}

# Summary Banner
Write-Host ""
Write-Host "==========================================="
Write-Host "PROJECT REVIEW READINESS"
Write-Host "==========================================="
Write-Host ""

if ($failedComponents.Count -eq 0) {
    Write-Host "READY FOR DEMO" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "NOT READY - Failed components:" -ForegroundColor Red
    foreach ($fc in $failedComponents) {
        Write-Host "  * $fc" -ForegroundColor Red
    }
    Write-Host ""
}
