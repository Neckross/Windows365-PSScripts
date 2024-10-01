#===================================================================================================================#
# Version     = 0.1
# Script Name = W365 - Log files from Intune scripts Remediate.ps1
# Description = This is a remediation script to cleanup Log files under C:\Temp folder in a Cloud PC.
# Notes       = No variable changes needed
#===================================================================================================================#

#Ensure the computer is a Cloud PC
if ($env:COMPUTERNAME -notlike "CPC-*") {
  write-host "This is not a Cloud PC. No remediation required."
  Exit 0
}

# Define the path to the Temp directory
$tempPath = "C:\Temp"
$fileExtensions = "*.log", "*.txt"
$logFiles = Get-ChildItem -Path $tempPath -Include $fileExtensions

if ($logFiles.Count -eq 0) {
  Write-Host "No .log or .txt files to delete under C:\Temp."
  Exit 0
}
else {
  # Try to delete each log file
  try {
    $logFiles | ForEach-Object {
      Write-Host "Deleting file: $($_.FullName)"
      Remove-Item -Path $_.FullName -Force
    }
    Write-Host "Files successfully deleted."
    Exit 0
  }
  catch {
    Write-Host "Failed to delete files."
    Exit 1
  }
}