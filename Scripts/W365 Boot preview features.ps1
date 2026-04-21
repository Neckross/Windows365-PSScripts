<#
    .SYNOPSIS
        Enables Windows 365 Boot preview features via registry keys.
    .NOTES
        Deployed via Intune as SYSTEM (device-targeted).
        Add new preview feature keys to the appropriate section below.
#>

# Ensure HKLM registry path exists
New-Item -Path "HKLM:\Software\Microsoft\Windows365" -Force | Out-Null

# --- Connection Center view (preview) ---
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "ProviderRedirectionForBoot" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "EnableLockOnDisconnect" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "Enable_Feature_NXTWindows365_ConnectionHotKeys" -PropertyType DWord -Value 1 -Force

# --- Enhanced Connectivity experience (preview) ---
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force

# Write HKCU key for each user profile (script runs as SYSTEM, so HKCU won't target real users)
$profileList = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" |
    Where-Object { $_.PSChildName -match '^S-1-5-21-' }
foreach ($profile in $profileList) {
    $sid = $profile.PSChildName
    $userHive = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows365"
    if (Test-Path "Registry::HKEY_USERS\$sid") {
        New-Item -Path $userHive -Force | Out-Null
        New-ItemProperty -Path $userHive -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force
    }
}

# --- Add new preview features below ---
