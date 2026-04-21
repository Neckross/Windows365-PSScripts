<#
    .SYNOPSIS
        Remediates Windows 365 Boot preview feature registry keys.
    .NOTES
        Intune Proactive Remediation - Remediation Script (runs as SYSTEM, device-targeted).
        Only runs when detection script exits with code 1.

    .CHANGELOG
        --- Preview Features & Registry Keys ---
        [Connection Center view]
            HKLM:\Software\Microsoft\Windows365
            - ProviderRedirectionForBoot      = 1 (DWord)
            - EnableLockOnDisconnect           = 1 (DWord)
            - Enable_Feature_NXTWindows365_ConnectionHotKeys = 1 (DWord)

        [Enhanced Connectivity experience]
            HKLM:\Software\Microsoft\Windows365
            - InSessionRdpProvider             = 2 (DWord)
            HKCU:\Software\Microsoft\Windows365  (per-user + Default profile)
            - InSessionRdpProvider             = 2 (DWord)

        --- Add new preview features here ---
#>

$basePath = "HKLM:\Software\Microsoft\Windows365"

# Ensure HKLM registry path exists
New-Item -Path $basePath -Force | Out-Null

# --- Connection Center view (preview) ---
New-ItemProperty -Path $basePath -Name "ProviderRedirectionForBoot" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path $basePath -Name "EnableLockOnDisconnect" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path $basePath -Name "Enable_Feature_NXTWindows365_ConnectionHotKeys" -PropertyType DWord -Value 1 -Force

# --- Enhanced Connectivity experience (preview) ---
New-ItemProperty -Path $basePath -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force

# Write HKCU key for each loaded user profile
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

# Write HKCU key to Default User profile (applies to future logins)
$defaultHive = "C:\Users\Default\NTUSER.DAT"
$tempKey = "HKU\DefaultUserTemp"
$loaded = $false
if (Test-Path $defaultHive) {
    reg load $tempKey $defaultHive 2>$null
    if ($LASTEXITCODE -eq 0) { $loaded = $true }
    if ($loaded) {
        $defaultPath = "Registry::$tempKey\Software\Microsoft\Windows365"
        New-Item -Path $defaultPath -Force | Out-Null
        New-ItemProperty -Path $defaultPath -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force
        reg unload $tempKey 2>$null
    }
}

# --- Add new preview features above ---

Write-Output "W365 Boot preview feature keys applied successfully."
exit 0
