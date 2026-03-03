# Keys required to enable Connection Center view for W365 Boot (coming soon feature)
New-Item -Path "HKLM:\Software\Microsoft\Windows365" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "ProviderRedirectionForBoot" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "EnableLockOnDisconnect" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "Enable_Feature_NXTWindows365_ConnectionHotKeys" -PropertyType DWord -Value 1 -Force

# Keys required to enable Enhanced Connectivity experience for W365 Boot (coming soon feature)
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows365" -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows365" -Name "InSessionRdpProvider" -PropertyType DWord -Value 2 -Force
