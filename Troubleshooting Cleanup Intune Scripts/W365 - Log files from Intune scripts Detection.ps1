#===================================================================================================================#
# Version     = 0.1
# Script Name = W365 - Log files from Intune scripts Detection.ps1
# Description = This is a detection script that checks if Log files exist under C:\Temp folder in a Cloud PC.
# Notes       = No variable changes needed
#===================================================================================================================#

#Ensure the computer is a Cloud PC
if ($env:COMPUTERNAME -notlike "CPC-*") {
  write-host "This is not a Cloud PC. No remdiation required."
  Exit 0
}

# Define the path to the Temp directory
$tempPath = "C:\Temp"
$fileExtensions = "*.log", "*.txt"
$logFiles = Get-ChildItem -Path $tempPath -Include $fileExtensions

if ($logFiles.Count -eq 0) {
  Write-Host "No .log or .txt files found under C:\Temp."
  Exit 0
}
else {
  Write-Host "Log and text files found under C:\Temp:."
  $logFiles | ForEach-Object { Write-Host $_.FullName }
  Exit 1
}
