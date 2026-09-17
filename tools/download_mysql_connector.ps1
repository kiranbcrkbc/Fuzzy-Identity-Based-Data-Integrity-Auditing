$ErrorActionPreference = 'Stop'
$url = "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar"
$webLibDir = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\SOURCE CODE\Fuzzy_IDbased_DataIntegrity\web\WEB-INF\lib"
$mysqlDriverDir = "c:\Users\a\OneDrive\Desktop\FUZZY\Fuzzy identity\SOURCE CODE\Fuzzy_IDbased_DataIntegrity\lib\MySQLDriver"

$target1 = Join-Path $webLibDir "mysql-connector-j-8.0.33.jar"
$target2 = Join-Path $mysqlDriverDir "mysql-connector-j-8.0.33.jar"

Write-Host "Downloading mysql-connector-j-8.0.33.jar..."
& curl.exe -L -o $target1 $url
Copy-Item $target1 $target2 -Force

Write-Host "MySQL connector 8.0.33 installed successfully!"
