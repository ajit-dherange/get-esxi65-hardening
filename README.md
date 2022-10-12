# Get ESXi65 Hardening

This powershell script will extract security settings for the Vmware ESXi 6.5 Servers

List server names in the text file "hosts.txt" (no matter one or many)

Current Security Settings will get listed (out put) in the file "ESXi.txt"

# How To .....

1. Download powershell script (Get-ESXi_65-Hardening-v3.ps1) and hosts list file (hosts.txt)

2. Update host file path in the first line of the script (E:\scripts\Get-ESXi_Hardening-Host\hosts.txt) 

3. Open powershell prompt

4. Connect to vCenter server (run below commands)

   $ Add-PSSnapin VMware.VimAutomation.Core

   $ Connect-VIServer -Server vCenter_server

5. Run the script

6. Open the output file to check the results
   
   $ notepad ESXi.txt
   
7. Update non-compliance setting on ESXi server if there is any 

