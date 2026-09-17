$ErrorActionPreference = 'Stop'
$toolsDir = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\tools"
$jdkDir = Join-Path $toolsDir "jdk8u442-b06"
$java = Join-Path $jdkDir "bin\java.exe"
$javac = Join-Path $jdkDir "bin\javac.exe"
$libDir = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\SOURCE CODE\Fuzzy_IDbased_DataIntegrity\web\WEB-INF\lib"

$cpList = (Get-ChildItem -Path (Join-Path $libDir "*.jar") | Select-Object -ExpandProperty FullName)
$cp = ($cpList -join ";") + ";" + $toolsDir

& $javac -cp $cp (Join-Path $toolsDir "TestDB.java")
& $java -cp $cp TestDB
