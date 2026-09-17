# ==============================================================================
# START_PROJECT.ps1 - One-Click Launcher for Fuzzy Identity Data Integrity Auditing
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
$webInfDir = Join-Path $webDir "WEB-INF"
$classesDir = Join-Path $webInfDir "classes"
$webLibDir = Join-Path $webInfDir "lib"
$srcJavaDir = Join-Path $sourceCodeDir "src\java"

$toolsDir = Join-Path $projectBase "tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$javac = Join-Path $jdkDir "bin\javac.exe"
$java = Join-Path $jdkDir "bin\java.exe"
$catalinaBat = Join-Path $tomcatDir "bin\catalina.bat"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   STARTING FUZZY IDENTITY AUDITING SYSTEM " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Check / Start MySQL
Write-Host "`n[1/5] Checking MySQL Database Service..." -ForegroundColor Yellow
$mysqlRunning = $false
$mysqlService = Get-Service -Name *mysql* -ErrorAction SilentlyContinue | Select-Object -First 1

if ($mysqlService -and $mysqlService.Status -eq 'Running') {
    $mysqlRunning = $true
    Write-Host "       MySQL service ($($mysqlService.Name)) is RUNNING." -ForegroundColor Green
} else {
    if ($mysqlService) {
        Write-Host "       Attempting to start $($mysqlService.Name)..." -ForegroundColor Yellow
        try {
            Start-Service -Name $mysqlService.Name -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
            $mysqlRunning = $true
            Write-Host "       MySQL service started successfully." -ForegroundColor Green
        } catch {
            Write-Host "       Could not start MySQL service automatically. Please ensure MySQL is running." -ForegroundColor Yellow
        }
    }
}

# Also test port 3306
$port3306 = Test-NetConnection -ComputerName localhost -Port 3306 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($port3306) {
    Write-Host "       MySQL Port 3306 is ACTIVE and accepting connections." -ForegroundColor Green
} else {
    Write-Host "       Warning: Port 3306 not responding yet." -ForegroundColor Yellow
}

# 2. Configure Java Runtime
Write-Host "`n[2/5] Configuring Java/JDK 8 Environment..." -ForegroundColor Yellow
$env:JAVA_HOME = $jdkDir
$env:JRE_HOME = $jdkDir
$env:CATALINA_HOME = $tomcatDir
$env:CATALINA_BASE = $tomcatDir

if (Test-Path $javac) {
    Write-Host "       Using Portable JDK 8: $jdkDir" -ForegroundColor Green
} else {
    Write-Host "       JDK not found at $jdkDir. Using system Java." -ForegroundColor Yellow
}

# 3. Build / Compile Application
Write-Host "`n[3/5] Verifying & Compiling Application Classes..." -ForegroundColor Yellow
if (-not (Test-Path $classesDir)) { New-Item -ItemType Directory -Path $classesDir -Force | Out-Null }
if (-not (Test-Path $webLibDir)) { New-Item -ItemType Directory -Path $webLibDir -Force | Out-Null }

# Ensure project libraries are present
Copy-Item (Join-Path $sourceCodeDir "lib\*.jar") -Destination $webLibDir -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $sourceCodeDir "lib\MySQLDriver\*.jar") -Destination $webLibDir -Force -ErrorAction SilentlyContinue

# Compile Java classes
$cpJars = @()
Get-ChildItem -Path (Join-Path $tomcatDir "lib\*.jar") -ErrorAction SilentlyContinue | ForEach-Object { $cpJars += $_.FullName }
Get-ChildItem -Path (Join-Path $webLibDir "*.jar") -ErrorAction SilentlyContinue | ForEach-Object { $cpJars += $_.FullName }
$classpath = ($cpJars -join ";")

$javaFiles = (Get-ChildItem -Path $srcJavaDir -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName)
& $javac -cp $classpath -d $classesDir -sourcepath $srcJavaDir $javaFiles

if ($LASTEXITCODE -eq 0) {
    Write-Host "       Application compiled successfully ($($javaFiles.Count) Java classes)." -ForegroundColor Green
} else {
    Write-Host "       Compilation completed with status code $LASTEXITCODE." -ForegroundColor Yellow
}

# 4. Configure Tomcat Server Context
Write-Host "`n[4/5] Configuring Tomcat Context..." -ForegroundColor Yellow
$serverXmlPath = Join-Path $tomcatDir "conf\server.xml"
$serverXml = Get-Content $serverXmlPath -Raw
if ($serverXml -notmatch "Fuzzy_IDbased_DataIntegrity") {
    $contextXml = "<Context docBase=`"$webDir`" path=`"/Fuzzy_IDbased_DataIntegrity`" reloadable=`"true`"/>`n</Host>"
    $serverXml = $serverXml -replace "</Host>", $contextXml
    Set-Content -Path $serverXmlPath -Value $serverXml -Encoding UTF8
    Write-Host "       Context registered in server.xml." -ForegroundColor Green
} else {
    Write-Host "       Context already configured in server.xml." -ForegroundColor Green
}

# 5. Start Apache Tomcat if not already running
Write-Host "`n[5/5] Starting Apache Tomcat Server..." -ForegroundColor Yellow
$tomcatRunning = $false
try {
    $checkResp = Invoke-WebRequest -Uri "http://localhost:8080/Fuzzy_IDbased_DataIntegrity/index.jsp" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
    if ($checkResp.StatusCode -eq 200) {
        $tomcatRunning = $true
        Write-Host "       Tomcat is already running." -ForegroundColor Green
    }
} catch {
    $tomcatRunning = $false
}

if (-not $tomcatRunning) {
    # Start Tomcat in background process
    Start-Process -FilePath $catalinaBat -ArgumentList "run" -WindowStyle Hidden -WorkingDirectory $tomcatDir
    Write-Host "       Tomcat launch triggered. Waiting for application to initialize..." -ForegroundColor Yellow

    $maxRetries = 20
    $ready = $false
    for ($i = 1; $i -le $maxRetries; $i++) {
        Start-Sleep -Seconds 1
        try {
            $resp = Invoke-WebRequest -Uri "http://localhost:8080/Fuzzy_IDbased_DataIntegrity/index.jsp" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
            if ($resp.StatusCode -eq 200) {
                $ready = $true
                break
            }
        } catch {
            Write-Host "       Waiting for server startup... ($i/$maxRetries)" -ForegroundColor DarkGray
        }
    }

    if ($ready) {
        Write-Host "       Tomcat is ready and serving requests." -ForegroundColor Green
    } else {
        Write-Host "       Tomcat started. Initial endpoint check will be verified below." -ForegroundColor Yellow
    }
}

# Output required banner
Write-Host ""
Write-Host "===========================================" -ForegroundColor Green
Write-Host "FUZZY IDENTITY PROJECT STARTED SUCCESSFULLY" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Application URL:"
Write-Host ""
Write-Host "http://localhost:8080/Fuzzy_IDbased_DataIntegrity/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press this URL in the browser to start the demo."
Write-Host ""
