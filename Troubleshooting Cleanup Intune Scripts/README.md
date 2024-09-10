# Troubleshooting Cleanup Intune Scripts
This is a Proactive Remediation scripts solution to automatically cleanup log files stored under C:\Temp for Intune scripts troubleshooting in a Cloud PC.

## For reference
When working with Intune Proactive Remediation scripts, you might find a need to troubleshoot erros or failed runs, for that matter is important to log files.
If you've been following this project, you'll notice that every script has a written log stored under C:\Temp folder in a Cloud PC.
Which in time those files can get bigger and potentially increase disk size if not properly maintenance.

### Intune Management Extension Logs
Optionally, you can rely on IME agent logs stored on a Intune managed device under "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs".
[Click Here](https://learn.microsoft.com/en-us/mem/intune/apps/intune-management-extension#intune-management-extension-logs)

## Solution outcome
The solution aims to automate a Log files cleanup in C:\Temp folder from interacting with Intune Proactive Remediation scripts.

## Using this solution
> Note: The scripts are not signed. If your organization is blocking the execution of unsigned scripts, they will not run.

### Detection Script
The detection script checks if the computer is a Cloud PC or not, as the script will not run on physical PCs.
The script will check for log and text files stored under C:\Temp folder in a Cloud PC.

> IMPORTANT: Download script and Upload to Intune Proactive Remediation scripts blade.

### Remediation Script
The remediation script fuels from the detection script, and will attempt to cleanup files stored under C:\Temp folder in a Cloud PC.

> IMPORTANT: Download script and Upload to Intune Proactive Remediation scripts blade.
