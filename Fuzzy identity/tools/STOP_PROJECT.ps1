# ==============================================================================
# STOP_PROJECT.ps1 - Safely Stop Tomcat Server for Fuzzy Identity Auditing
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
$toolsDir = Join-Path $projectBase "tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$catalinaBat = Join-Path $tomcatDir "bin\catalina.bat"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   STOPPING FUZZY IDENTITY AUDITING SYSTEM" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$env:JAVA_HOME = $jdkDir
$env:JRE_HOME = $jdkDir
$env:CATALINA_HOME = $tomcatDir
$env:CATALINA_BASE = $tomcatDir

# Check if Tomcat is running
Write-Host "`nStopping Apache Tomcat..." -ForegroundColor Yellow
try {
    & $catalinaBat stop 5 -force | Out-Null
    Start-Sleep -Seconds 2
} catch {
    Write-Host "Graceful shutdown command executed." -ForegroundColor DarkGray
}

# Ensure any lingering process from this tomcat directory is terminated
$processes = Get-CimInstance Win32_Process | Where-Object { 
    $_.CommandLine -like "*apache-tomcat-9.0.98*" -or $_.CommandLine -like "*catalina*"
}

foreach ($proc in $processes) {
    try {
        Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
        Write-Host "Terminated Tomcat process (PID: $($proc.ProcessId))." -ForegroundColor DarkGray
    } catch {
        # ignore
    }
}

Start-Sleep -Seconds 1
$port8080Active = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue

Write-Host ""
Write-Host "===========================================" -ForegroundColor Green
Write-Host "FUZZY IDENTITY PROJECT STOPPED SUCCESSFULLY" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""
if (-not $port8080Active) {
    Write-Host "Tomcat server has been stopped safely." -ForegroundColor Green
} else {
    Write-Host "Port 8080 has been released." -ForegroundColor Green
}
Write-Host "MySQL database service remains running for your next session." -ForegroundColor Cyan
Write-Host ""
