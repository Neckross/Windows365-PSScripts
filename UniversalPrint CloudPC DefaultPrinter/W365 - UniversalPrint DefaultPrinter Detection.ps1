#===================================================================================================================#
# Version     = 0.4
# Script Name = W365 - UniversalPrint DefaultPrinter Detection.ps1
# Description = This is a detection script that checks if a Universal Printer share is set as default in a Cloud PC.
# Notes       = Variable MUST be updated $printerName
#===================================================================================================================#

# Define the log file location
$logFile = "C:\Temp\PrinterDetectionLog.txt"

# Function to write log entries
function Write-Log {
  param (
    [string]$message
  )
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $logEntry = "$timestamp - $message"
  Write-Host $logEntry
  $logEntry | Out-File -FilePath $logFile -Append
}

# Ensure the computer is a Cloud PC
if ($env:COMPUTERNAME -notlike "CPC-*") {
  Write-Log "This is not a Cloud PC. No remediation required."
  Exit 0
}

# Define the target printer name
$printerName = "Canon TS6400 series"  <############MUST UPDATE with the Universal Print share name############>

# Log the start of the detection process
Write-Log "Starting printer detection for '$printerName'."

# Check if the printer is installed
$printer = Get-CimInstance -Class Win32_Printer | Where-Object { $_.Name -eq $printerName }

if ($null -eq $printer) {
  # Printer is not installed
  Write-Log "Printer '$printerName' is not installed, cannot continue."
  Exit 1
}
else {
  # Printer is installed
  Write-Log "Printer '$printerName' is installed."

  # Check if the installed printer is set as default
  if ($printer.Default -eq $true) {
    Write-Log "Printer '$printerName' is already the default."
    Exit 0
  }
  else {
    Write-Log "Printer '$printerName' is not set as default."
    Exit 1
  }
}
