#===================================================================================================================#
# Version     = 0.1
# Script Name = W365 - UniversalPrint DefaultPrinter Remediation.ps1
# Description = This is a remediation script that checks if Universal Printer share is set as default in a Cloud PC.
# Notes       = Variable MUST be updated $printerName
#===================================================================================================================#

#Ensure the computer is a Cloud PC
if ($env:COMPUTERNAME -notlike "CPC-*") {
  write-host "This is not a Cloud PC. No remdiation required."
  Exit 0
}

# Define the target printer name
$printerName = "Canon MG3600 series" <#MUST UPDATE with the Universal Printer Share Name#>

# Check if the printer is installed or set as default
$printer = Get-CimInstance -Class Win32_Printer | Where-Object { $_.Name -eq $printerName }

if ($null -eq $printer) {
  Write-Host "Printer '$printerName' is not installed, cannot continue."
  Exit 1
}
elseif ($printer.Default -eq $true) {
  Write-Host "Printer '$printerName' is already the default."
  Exit 0
}

# Set the printer as default
try {
  Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter
  Write-Host "Printer '$printerName' set as the default."
  Exit 0
}
catch {
  Write-Host "Failed to set printer '$printerName' as the default."
  Exit 1
}
