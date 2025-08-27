# Windows Setup Script
# Based on configuration instructions from Bez názvu.txt

# Require admin privileges
#Requires -RunAsAdministrator

Write-Host "Starting Windows setup configuration..." -ForegroundColor Green

# 1. Network Settings - Set network as private
Write-Host "Configuring network settings..." -ForegroundColor Yellow
$networkProfiles = Get-NetConnectionProfile
foreach ($profile in $networkProfiles) {
    Set-NetConnectionProfile -InterfaceIndex $profile.InterfaceIndex -NetworkCategory Private
}

# Enable file and printer sharing for private networks
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"
Enable-NetFirewallRule -DisplayGroup "Network Discovery"

# 2. TightVNC installation note
Write-Host "Note: Install TightVNC 64-bit version manually from tightvnc.com" -ForegroundColor Cyan
Write-Host "- Custom installation - server only" -ForegroundColor Cyan
Write-Host "- Configure password for remote access" -ForegroundColor Cyan
Write-Host "- After installation: disable web access 5800, Hide Desktop, Show Icon notifications" -ForegroundColor Cyan

# 3. Windows Update configuration
Write-Host "Configuring Windows Update..." -ForegroundColor Yellow
# Enable updates for other Microsoft products
try {
    $updateConfig = New-Object -ComObject Microsoft.Update.ServiceManager
    $updateService = $updateConfig.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
    Write-Host "Microsoft Update service enabled" -ForegroundColor Green
} catch {
    Write-Host "Failed to configure Microsoft Update service: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. System Restore configuration
Write-Host "Configuring System Restore..." -ForegroundColor Yellow
try {
    Enable-ComputerRestore -Drive "C:\"
    vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5GB
    Write-Host "System Restore configured" -ForegroundColor Green
} catch {
    Write-Host "Failed to configure System Restore: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. Remote Desktop configuration
Write-Host "Configuring Remote Desktop..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1

# 6. Power settings - disable sleep when plugged in
Write-Host "Configuring power settings..." -ForegroundColor Yellow
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0

# 7. Desktop icons configuration
Write-Host "Configuring desktop icons..." -ForegroundColor Yellow
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -ErrorAction SilentlyContinue # This PC
Set-ItemProperty -Path $regPath -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Value 0 -ErrorAction SilentlyContinue # Control Panel
Set-ItemProperty -Path $regPath -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Value 0 -ErrorAction SilentlyContinue # Network

# 8. Taskbar customization
Write-Host "Configuring taskbar..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 # Hide search
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 # Hide task view
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 # Hide widgets

# 9. Taskbar alignment
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 # Left align

# 10. File Explorer settings
Write-Host "Configuring File Explorer..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 # Show file extensions

# 11. Network sharing for domain networks
Write-Host "Enabling network sharing for domain networks..." -ForegroundColor Yellow
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes profile=domain
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes profile=domain

# 12. Microsoft Store app updates
Write-Host "Updating Microsoft Store apps..." -ForegroundColor Yellow
try {
    Start-Process ms-windows-store://downloadsandupdates -WindowStyle Hidden
    Write-Host "Microsoft Store update initiated" -ForegroundColor Green
} catch {
    Write-Host "Failed to update Microsoft Store apps: $($_.Exception.Message)" -ForegroundColor Red
}

# 13. Winget updates
Write-Host "Running winget updates..." -ForegroundColor Yellow
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget upgrade --all --accept-source-agreements --accept-package-agreements
} else {
    Write-Host "Winget not available, skipping updates" -ForegroundColor Red
}

# 14. Software installation notes
Write-Host "`nManual installation required for:" -ForegroundColor Cyan
Write-Host "- 7-Zip" -ForegroundColor Cyan
Write-Host "- Adobe Reader (set as default for PDF)" -ForegroundColor Cyan
Write-Host "- Kerio Offline Connector from: https://mail.nemecpolak.cz" -ForegroundColor Cyan
Write-Host "- Total Commander (for all users, no desktop icon)" -ForegroundColor Cyan

# 15. Uninstall bloatware reminder
Write-Host "`nRemember to uninstall unnecessary software:" -ForegroundColor Yellow
Write-Host "- Third-party antiviruses, games, manufacturer bloatware (HP OneAgent, etc.)" -ForegroundColor Yellow

Write-Host "`nWindows setup configuration completed!" -ForegroundColor Green
Write-Host "Please complete manual installations and restart the computer." -ForegroundColor Green

# Restart prompt
$restart = Read-Host "`nWould you like to restart now? (y/n)"
if ($restart -eq "y" -or $restart -eq "Y") {
    Restart-Computer -Force
}