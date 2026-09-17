# ==============================================================================
# START_TUNNEL.ps1 - Expose Local Tomcat to Public Internet via HTTPS Tunnel
# ==============================================================================
$ErrorActionPreference = 'Stop'

Write-Host "Starting Public HTTPS Tunnel for Tomcat on port 8080..." -ForegroundColor Cyan
Write-Host "This provides a live public URL for external smartphones, laptops, and examiners.`n" -ForegroundColor Yellow

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -T -R 80:localhost:8080 nokey@localhost.run
