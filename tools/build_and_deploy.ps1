# ==============================================================================
# build_and_deploy.ps1 - Reproducible Clean Build, WAR Package & Tomcat Deploy
# ==============================================================================
$ErrorActionPreference = 'Stop'

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

$projectRoot = Resolve-ProjectBase
$sourceCodeDir = Join-Path $projectRoot "SOURCE CODE\Fuzzy_IDbased_DataIntegrity"
$webDir = Join-Path $sourceCodeDir "web"
$webInfDir = Join-Path $webDir "WEB-INF"
$classesDir = Join-Path $webInfDir "classes"
$webLibDir = Join-Path $webInfDir "lib"
$srcJavaDir = Join-Path $sourceCodeDir "src\java"

$toolsDir = Join-Path $projectRoot "tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$javac = Join-Path $jdkDir "bin\javac.exe"
$jarExe = Join-Path $jdkDir "bin\jar.exe"

Write-Host "Creating target directories..." -ForegroundColor Cyan
if (-not (Test-Path $classesDir)) { New-Item -ItemType Directory -Path $classesDir -Force | Out-Null }
if (-not (Test-Path $webLibDir)) { New-Item -ItemType Directory -Path $webLibDir -Force | Out-Null }

Write-Host "Syncing project libraries to WEB-INF/lib..." -ForegroundColor Cyan
Copy-Item (Join-Path $sourceCodeDir "lib\*.jar") -Destination $webLibDir -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $sourceCodeDir "lib\MySQLDriver\*.jar") -Destination $webLibDir -Force -ErrorAction SilentlyContinue

Write-Host "Building compilation classpath..." -ForegroundColor Cyan
$cpJars = @()
Get-ChildItem -Path (Join-Path $tomcatDir "lib\*.jar") -ErrorAction SilentlyContinue | ForEach-Object { $cpJars += $_.FullName }
Get-ChildItem -Path (Join-Path $webLibDir "*.jar") -ErrorAction SilentlyContinue | ForEach-Object { $cpJars += $_.FullName }
$classpath = ($cpJars -join ";")

Write-Host "Finding Java source files..." -ForegroundColor Cyan
$javaFiles = (Get-ChildItem -Path $srcJavaDir -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName)

Write-Host "Compiling $($javaFiles.Count) Java classes with JDK 8..." -ForegroundColor Cyan
& $javac -cp $classpath -d $classesDir -sourcepath $srcJavaDir $javaFiles

if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilation failed with exit code $LASTEXITCODE"
}
Write-Host "Compilation SUCCESSFUL!" -ForegroundColor Green

# Generate standard production WAR archive
Write-Host "Packaging standard production WAR archive..." -ForegroundColor Cyan
$distDir = Join-Path $sourceCodeDir "dist"
if (-not (Test-Path $distDir)) { New-Item -ItemType Directory -Path $distDir -Force | Out-Null }
$warPath = Join-Path $distDir "Fuzzy_IDbased_DataIntegrity.war"

if (Test-Path $jarExe) {
    Push-Location $webDir
    try {
        & $jarExe cvf $warPath * | Out-Null
        Write-Host "Generated WAR archive: $warPath" -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

Write-Host "Configuring Tomcat server.xml and context..." -ForegroundColor Cyan
$serverXmlPath = Join-Path $tomcatDir "conf\server.xml"
$serverXml = Get-Content $serverXmlPath -Raw

if ($serverXml -notmatch "Fuzzy_IDbased_DataIntegrity") {
    $contextXml = "<Context docBase=`"$webDir`" path=`"/Fuzzy_IDbased_DataIntegrity`" reloadable=`"true`"/>`n</Host>"
    $serverXml = $serverXml -replace "</Host>", $contextXml
    Set-Content -Path $serverXmlPath -Value $serverXml -Encoding UTF8
    Write-Host "Context /Fuzzy_IDbased_DataIntegrity configured in Tomcat server.xml!" -ForegroundColor Green
} else {
    Write-Host "Context already configured in server.xml." -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "  BUILD & DEPLOYMENT PREPARATION COMPLETE " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
