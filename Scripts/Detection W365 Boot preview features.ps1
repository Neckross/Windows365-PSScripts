<#
    .SYNOPSIS
        Detects whether Windows 365 Boot preview feature registry keys are correctly set.
    .NOTES
        Intune Proactive Remediation - Detection Script (runs as SYSTEM, device-targeted).
        Exit 0 = Compliant | Exit 1 = Non-compliant (triggers remediation).

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

# Define expected HKLM keys and values
$expectedKeys = @(
    @{ Name = "ProviderRedirectionForBoot"; Value = 1 }   # Connection Center view
    @{ Name = "EnableLockOnDisconnect"; Value = 1 }        # Connection Center view
    @{ Name = "Enable_Feature_NXTWindows365_ConnectionHotKeys"; Value = 1 }  # Connection Center view
    @{ Name = "InSessionRdpProvider"; Value = 2 }          # Enhanced Connectivity
)

# Check HKLM keys
if (-not (Test-Path $basePath)) {
    Write-Output "HKLM path missing: $basePath"
    exit 1
}

foreach ($key in $expectedKeys) {
    $current = Get-ItemProperty -Path $basePath -Name $key.Name -ErrorAction SilentlyContinue
    if ($null -eq $current -or $current.($key.Name) -ne $key.Value) {
        Write-Output "HKLM key missing or incorrect: $($key.Name)"
        exit 1
    }
}

# Check HKCU key for each loaded user profile
$profileList = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" |
    Where-Object { $_.PSChildName -match '^S-1-5-21-' }

foreach ($profile in $profileList) {
    $sid = $profile.PSChildName
    if (Test-Path "Registry::HKEY_USERS\$sid") {
        $userPath = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows365"
        $current = Get-ItemProperty -Path $userPath -Name "InSessionRdpProvider" -ErrorAction SilentlyContinue
        if ($null -eq $current -or $current.InSessionRdpProvider -ne 2) {
            Write-Output "HKCU key missing or incorrect for SID: $sid"
            exit 1
        }
    }
}

# Check Default User profile hive for future logins
$defaultHive = "C:\Users\Default\NTUSER.DAT"
$tempKey = "HKU\DefaultUserTemp"
$loaded = $false
if (Test-Path $defaultHive) {
    reg load $tempKey $defaultHive 2>$null
    if ($LASTEXITCODE -eq 0) { $loaded = $true }
    $defaultPath = "Registry::$tempKey\Software\Microsoft\Windows365"
    $current = Get-ItemProperty -Path $defaultPath -Name "InSessionRdpProvider" -ErrorAction SilentlyContinue
    if ($loaded) { reg unload $tempKey 2>$null }
    if ($null -eq $current -or $current.InSessionRdpProvider -ne 2) {
        Write-Output "Default User profile HKCU key missing or incorrect: InSessionRdpProvider"
        exit 1
    }
}

Write-Output "All W365 Boot preview feature keys are compliant."
exit 0
