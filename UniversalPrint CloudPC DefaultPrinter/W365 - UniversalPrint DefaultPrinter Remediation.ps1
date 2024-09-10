#===================================================================================================================#
# Version     = 0.5
# Script Name = W365 - UniversalPrint DefaultPrinter Remediation.ps1
# Description = This is a remediation script that checks if Universal Printer share is set as default in a Cloud PC.
# Notes       = Variable MUST be updated $printerName
#===================================================================================================================#

# Define the log file location
$logFolder = "C:\Temp"
$logFile = "$logFolder\PrinterRemediationLog.txt"

# Ensure the log folder exists
if (-not (Test-Path -Path $logFolder)) {
  New-Item -Path $logFolder -ItemType Directory | Out-Null
}

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
$printerName = "Canon TS6400 series"  # MUST UPDATE with the Universal Print share name

# Log the start of the remediation process
Write-Log "Starting remediation to set '$printerName' as the default printer."

# Check if the printer is installed or already set as default
$printer = Get-CimInstance -Class Win32_Printer | Where-Object { $_.Name -eq $printerName }

if ($null -eq $printer) {
  Write-Log "Printer '$printerName' is not installed, cannot continue."
  Exit 1
}
elseif ($printer.Default -eq $true) {
  Write-Log "Printer '$printerName' is already the default."
  Exit 0
}

# Set the printer as default
try {
  Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter
  Write-Log "Printer '$printerName' set as the default."
  Exit 0
}
catch {
  Write-Log "Failed to set printer '$printerName' as the default."
  Exit 1
}
