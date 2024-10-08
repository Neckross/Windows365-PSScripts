# Universal Print for Cloud PC
This is a Proactive Remediation scripts solution to automatically set a Universal Print "printer share" as default in a Cloud PC.

## For reference
Universal Print is a cloud native solution that allows you to publish organization printers to azure cloud.
You can use Intune Setting Catalog policies to deploy the "printer share" and map automatically to the users windows profile.
For Windows 365 Cloud PCs, this is a great advantage as users can roam sessions with connected cloud printers through many terminals or endpoints.

* Universal Print docs:
[Click Here](https://learn.microsoft.com/en-us/universal-print/discover-universal-print)

* Intune + Universal Print docs:
[Click Here](https://learn.microsoft.com/en-us/mem/intune/configuration/settings-catalog-printer-provisioning)

* Intune Proactive Remediation docs:
[Click Here](https://learn.microsoft.com/en-us/mem/intune/fundamentals/remediations)

## Solution outcome
Today Intune does not have native built-in policy to set a printer as default, that's what this solution aims to automate.

## Using this solution
> Note: The scripts are not signed. If your organization is blocking the execution of unsigned scripts, they will not run.

### Detection Script
The detection script checks if the computer is a Cloud PC or not, as the script will not run on physical PCs.
The script will check if the Universal Printer share is installed and configured as default.
For troubleshooting, there's a written log file stored under C:\Temp in the Cloud PC.

> IMPORTANT: you MUST set "$printerName" value. Download/Update script and Upload to Intune Proactive Remediation scripts blade.

> REMINDER: you MUST set script to run in user-context "Run this script using logged-on credentials", because Universal Printers are deployed via user-context.

### Remediation Script
The remediation script fuels from the detection script, and will attempt to set the Universal Printer share as default.
For troubleshooting, there's a written log file stored under C:\Temp in the Cloud PC.

> IMPORTANT: you MUST set "$printerName" value. Copy/Update script and Upload to Intune Proactive Remediation scripts blade.

> REMINDER: you MUST set script to run in user-context "Run this script using logged-on credentials", because Universal Printers are deployed via user-context.
