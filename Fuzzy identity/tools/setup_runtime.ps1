# ==============================================================================
# setup_runtime.ps1 - Automated Prerequisite Setup for OpenJDK 8 & Tomcat 9
# ==============================================================================
$ErrorActionPreference = 'Stop'

$toolsDir = $PSScriptRoot
$projectRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
}

$tomcatZip = Join-Path $toolsDir "tomcat9.zip"
$jdkZip = Join-Path $toolsDir "jdk8.zip"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"

if (-not (Test-Path $tomcatDir)) {
    Write-Host "Downloading Apache Tomcat 9.0.98..." -ForegroundColor Cyan
    & curl.exe -L -o $tomcatZip "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98-windows-x64.zip"
    Write-Host "Extracting Apache Tomcat 9..." -ForegroundColor Cyan
    Expand-Archive -Path $tomcatZip -DestinationPath $toolsDir -Force
    Remove-Item $tomcatZip -Force
} else {
    Write-Host "Apache Tomcat 9.0.98 already present." -ForegroundColor Green
}

if (-not (Test-Path $jdkDir)) {
    Write-Host "Downloading OpenJDK 8 (Temurin 8u442)..." -ForegroundColor Cyan
    & curl.exe -L -o $jdkZip "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u442-b06/OpenJDK8U-jdk_x64_windows_hotspot_8u442b06.zip"
    Write-Host "Extracting OpenJDK 8..." -ForegroundColor Cyan
    Expand-Archive -Path $jdkZip -DestinationPath $toolsDir -Force
    Remove-Item $jdkZip -Force
} else {
    Write-Host "OpenJDK 8 (jdk8u442-b06) already present." -ForegroundColor Green
}

# Configure setenv.bat inside Tomcat bin to point dynamically to the bundled JDK 8
$setenvFile = Join-Path $tomcatDir "bin\setenv.bat"
$setenvContent = "@echo off`r`nfor %%i in (`"%~dp0..\..\jdk8u442-b06`") do set `"JAVA_HOME=%%~fi`"`r`nset `"JRE_HOME=%JAVA_HOME%`"`r`nfor %%i in (`"%~dp0..`") do set `"CATALINA_HOME=%%~fi`"`r`n"
[System.IO.File]::WriteAllText($setenvFile, $setenvContent)

Write-Host "`nSetup completed successfully! Environment is ready for build and run." -ForegroundColor Green
