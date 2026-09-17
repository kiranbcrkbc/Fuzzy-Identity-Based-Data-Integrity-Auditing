$ErrorActionPreference = 'Stop'
$projectRoot = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity"
$toolsDir = Join-Path $projectRoot "tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$tomcatDir = Join-Path $toolsDir "apache-tomcat-9.0.98"
$catalinaBat = Join-Path $tomcatDir "bin\catalina.bat"

$env:JAVA_HOME = $jdkDir
$env:JRE_HOME = $jdkDir
$env:CATALINA_HOME = $tomcatDir

Write-Host "Starting Apache Tomcat 9 with JDK 8..."
& $catalinaBat run
