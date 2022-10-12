$esxihosts = get-content E:\scripts\Get-ESXi_Hardening-Host\hosts.txt

Write-Output "### ESXi.apply-patches" > ESXi.txt
echo "---------------------------------------" >> ESXi.txt
Get-VMHost $esxihosts | select Name,Build,Version | ft -AutoSize >> ESXi.txt

Write-Output "### ESXi.audit-exception-users" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
Write-output "Exception Users from Host" >> ESXi.txt
$myhost = Get-VMHost $esxihost | Get-View
$lockdown = Get-View $myhost.ConfigManager.HostAccessManager
$LDusers = $lockdown.QueryLockdownExceptions()
Write-output $LDusers`n >> ESXi.txt
}

Write-Output "### ESXi.Audit-SSH-Disable" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
Get-VMHost $esxihost | Get-VMHostService | Where-Object {$_.Key -eq "TSM-SSH"} | select key,Label,Running | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.config-ntp" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Select @{N="NTPSetting";E={$_ | Get-VMHostNtpServer}} >> ESXi.txt
}

Write-Output "### ESXi.config-persistent-logs" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name Syslog.global.logDir  | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.config-snmp" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
  Write-output "Host is: $esxihost "  >> ESXi.txt
  Get-VMHost $esxihost | foreach { get-vmhostservice -VMHost $_.name | where {$_.Key -eq "SNMPD"}} | select key,Label,Running | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.disable-mob" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
  Write-output "Host is: $esxihost "  >> ESXi.txt
  Get-VMHost $esxihost | Get-AdvancedSetting -Name Config.HostAgent.plugins.solo.enableMob | select Name,Value | ft -AutoSize >> ESXi.txt  
}

Write-Output "### ESXi.UserVars.ESXiVPsDisabledProtocols" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name UserVars.ESXiVPsDisabledProtocols | select Name,Value |  ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.enable-ad-auth" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
Get-VMHost $esxihost | Get-VMHostAuthentication | Select VmHost, Domain | ft -AutoSize >> ESXi.txt 
}

Write-Output "### ESXi.enable-auth-proxy" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
Get-VMHost $esxihost | Select ` @{N="HostProfile";E={$_ | Get-VMHostProfile}}, ` @{N="JoinADEnabled";E={($_ | Get-VmHostProfile).ExtensionData.Config.ApplyProfile.Authentication.ActiveDirectory.Enabled}}, ` @{N="JoinDomainMethod";E={(($_ | Get-VMHostProfile).ExtensionData.Config.ApplyProfile.Authentication.ActiveDirectory | Select -ExpandProperty Policy | Where {$_.Id -eq "JoinDomainMethodPolicy"}).Policyoption.Id}}
}

Write-Output "### ESXi.enable-chap-auth" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
Get-VMHost $esxihosts | Get-VMHostHba | Where{$_.Type -eq "iscsi"} | ft -AutoSize >> ESXi.txt 
}


Write-Output "### ESXi.enable-normal-lockdown-mode" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
 Write-output "Host is: $esxihost "  >> ESXi.txt
 $a=Get-VMHost $esxihost 
 $a.Extensiondata.Config.adminDisabled >> ESXi.txt
}


Write-Output "### ESXi.enable-remote-syslog" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
 Write-output "Host is: $esxihost "  >> ESXi.txt
 Get-VMHost $esxihost | Select @{N="Syslog.global.logHost";E={$_ | Get-VMHostAdvancedConfiguration Syslog.global.logHost | Select -ExpandProperty Values}} >> ESXi.txt
}


Write-Output "### ESXi.firewall-enabled" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
echo "List the services which are defined for specific IP ranges to access the service`n" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost "  >> ESXi.txt
Get-VMHost $esxihost | Get-VMHostFirewallException | Where {(-not $_.ExtensionData.AllowedHosts.AllIP)} >> ESXi.txt
}

Write-Output "### ESXi.set-account-auto-unlock-time" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name Security.AccountUnlockTime | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.set-account-lockout" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name Security.AccountLockFailures | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.set-dcui-access" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name DCUI.Access | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.set-dcui-timeout" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name UserVars.DcuiTimeOut | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.set-password-policies" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name Security.PasswordQualityControl | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.set-shell-interactive-timeout" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name UserVars.ESXiShellInteractiveTimeOut | select Name,Value | ft -AutoSize >> ESXi.txt
}


Write-Output "### ESXi.set-shell-timeout" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name UserVars.ESXiShellTimeOut | select Name,Value | ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.TransparentPageSharing-intra-enabled" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
Get-VMHost $esxihost | Get-AdvancedSetting -Name Mem.ShareForceSalting | select Name,Value |  ft -AutoSize >> ESXi.txt
}

Write-Output "### ESXi.verify-acceptance-level-certified" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
$esxcli = Get-EsxCli -VMHost $esxihost
$esxcli.software.acceptance.get() >> ESXi.txt
}

Write-Output "### Create Warning Banners" >> ESXi.txt
echo "---------------------------------------" >> ESXi.txt
foreach ($esxihost in $esxihosts)
{
Write-output "Host is: $esxihost `n "  >> ESXi.txt
$m = Get-VMHost $esxihost | Get-AdvancedSetting -Name Annotations.WelcomeMessage | select Value  |  ft -AutoSize 
Out-String -InputObject $m -Width 360 | ft -AutoSize >> ESXi.txt
}
