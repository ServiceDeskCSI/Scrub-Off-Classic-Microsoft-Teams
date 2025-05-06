# ================================
# Remove Classic Teams - All Users
# ================================

# 1. Uninstall Classic Teams (Machine-wide Installer if present)
Write-Host "🔍 Checking for Classic Teams machine-wide installer..."
$machineInstaller = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Teams Machine*" }
if ($machineInstaller) {
    Write-Host "🗑 Uninstalling Teams Machine-Wide Installer..."
    $machineInstaller.Uninstall()
} else {
    Write-Host "✅ No Teams Machine-Wide Installer found."
}

# 2. Remove Teams from ALL user profiles
$profiles = Get-ChildItem 'C:\Users' -Exclude 'Public','Default','Default User','All Users'

foreach ($profile in $profiles) {
    $userProfile = $profile.FullName

    # Remove Teams AppData
    $teamsAppPath = Join-Path $userProfile 'AppData\Local\Microsoft\Teams'
    if (Test-Path $teamsAppPath) {
        Write-Host "🧹 Removing Teams AppData from $userProfile"
        Remove-Item -Path $teamsAppPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Remove Teams shortcut from Start Menu
    $startMenuPath = Join-Path $userProfile 'AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk'
    if (Test-Path $startMenuPath) {
        Write-Host "🧹 Removing Teams Start Menu shortcut from $userProfile"
        Remove-Item $startMenuPath -Force -ErrorAction SilentlyContinue
    }

    # Remove Taskbar pinned Teams shortcut
    $taskbarPath = Join-Path $userProfile 'AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Teams.lnk'
    if (Test-Path $taskbarPath) {
        Write-Host "🧹 Removing Teams Taskbar shortcut from $userProfile"
        Remove-Item $taskbarPath -Force -ErrorAction SilentlyContinue
    }
}

# 3. Remove Public desktop shortcut
$publicDesktop = 'C:\Users\Public\Desktop\Microsoft Teams.lnk'
if (Test-Path $publicDesktop) {
    Write-Host "🧹 Removing public desktop shortcut"
    Remove-Item $publicDesktop -Force
}

Write-Host "`n✅ Classic Teams cleanup completed."
