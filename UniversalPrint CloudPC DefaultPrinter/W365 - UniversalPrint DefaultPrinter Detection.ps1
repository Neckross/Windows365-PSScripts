#===================================================================================================================#
#
# Version     = 0.1
# Script Name = W365 - UniversalPrint DefaultPrinter Detection.ps1
# Description = This is a detection script that checks if a Universal Printer share is set as default in a Cloud PC.
# Notes       = Variable MUST be updated $printerName
#
#===================================================================================================================#

#Ensure the computer is a Cloud PC
if ($env:COMPUTERNAME -notlike "CPC-*") {
  write-host "This is not a Cloud PC. No remdiation required."
  Exit 0
}

# Define the target printer name
$printerName = "Canon MG3600 series" <#MUST UPDATE with the Universal Printer Share Name#>

# Check if the printer is installed
$printer = Get-CimInstance -Class Win32_Printer | Where-Object { $_.Name -eq $printerName }

if ($null -eq $printer) {
  # Printer is not installed
  Write-Host "Printer '$printerName' is not installed, cannot continue."
  Exit 1
}
else {
  # Printer is installed
  Write-Host "Printer '$printerName' is installed."

  # Check if the installed printer is set as default
  if ($printer.Default -eq $true) {
    Write-Host "Printer '$printerName' is already the default."
    Exit 0
  }
  else {
    Write-Host "Printer '$printerName' is not set as default."
    Exit 1
  }
}
