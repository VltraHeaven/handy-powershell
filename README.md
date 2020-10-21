# Essential Powershell

![logo](https://dashboard.snapcraft.io/site_media/appmedia/2018/09/Powershell_av_colors.ico.png)

## Scripts

- [addGroupMembership](addGroupMembership.ps1)
- [getUserInfo](getUserInfo.ps1)

## Basic Commands

`Rename-Computer {hostname}`
- Changes the target machine's hostname

`Restart-Computer {comment} - ComputerName {hostname}`
- Restarts the target machine

`Stop-Computer -ComputerName {hostname}`
-  Restarts the target machine

`Get-NetIPConfiguration`
- Gets the IP address of the target machine

`Get-Command`
- Gets information for the target powershell commandlet

`Get-Command -Noun {commandnoun}`
- Displays every commandlet for the given commandlet noun

## Networking

`New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress {ipaddress} -PrefixLength {prefix} -DefaultGateway {gatewayipaddress}`
- Statically sets the target machine's IP address

`Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses {dnsipaddress}`
- Sets DNS servers for the target machine

`Add-Computer -ComputerName {oldcomputername} -NewName {newcomputername} -DomainName {domainname} -DomainCredential {domainusername}`
- Adds the target machine to a domain

`Get-NetAdapterStatistics`
- Shows the name and stats for the target machine's network adapters

`Test-NetConnection {ipaddress/hostname}`
- Verifies the target machine's network connectivity

`Test-NetConnection {ipaddress/hostname} -traceroute`
- Displays route from target machine to destination host

`Test-NetConnection {ipaddress/hostname} -Port {port}`
- Performs a port check for the destination host

`Get-Eventlog -logname System -EntryType Error`
-  View the error event logs

## System Services

`Stop-Service`
- Stops the target service

`Start-Service`
- Starts the target service

`Restart-Service`
- Restarts the target service

`Set-Service`
- Sets the target service to desired state

`Get-Service`
- Gets status of the target service

`Get-Service | Where-Object {$_.Status -eq "Stopped"}`
- Shows all stopped services for the target machine

## Roles and Features

`Get-WindowsFeature`
- displays every Windows feature available for the target machine

`Install-WindowsFeature -Name {featurename} -Restart`
- Installs a feature on the target machine and restarts after installation

`Install-WindowsFeature -Name {featurename} -IncludeManagementTools {featuregroup}`
- Installs all Windows features for the given Windows feature group

`Install-WindowsFeature Net-Framework-Core -source {path}`
- Installs .NET Framework Core onto the target machine

`Remove-WindowsFeature -Name {featurename,featurename} -Restart`
- Removes the specified feature(s) from the target machine and restarts upon completion

## Updates

`Get-Hotfix`
- Displays a list of all installed updates for the target machine

## Firewall

`New-NetFirewallRule -DisplayName {ruledisplayname} -Direction {Inbound/Outbound} -LocalPort {port} -Protocol {TCP/UDP} -Action {Allow/Block}`
- Adds the desired firewall rule to the target machine

## Hyper-V

`New-VM -MemoryStartupBytes {memorysize} -Name {vmname} -Path {path} -VHDPath "{path}\{diskname}.vhdx"`
- Create a new VM from a `.vhdx` template

`Get-VM -name {vmname} | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname {switchname}`
- Assign the network adapter of the target vm to a virtual switch

## Powershell Direct

Allows the SysAdmin to run Powershell commands from the Hyper-V host inside a VM without remote connections (RDP, VNC, ssh, etc.) Windows 10 Server 2016 only.

`Enter-PSSession -VMName {vmname}`
- Creates a Powershell Direct connection with the target vm

`Invoke-Command -VMName {vmname} -ScriptBlock {Commands}`
- Runs a command or set of commands on the target vm within an instantiated PSSession

## Active Directory

`$newpwd = ConvertTo-SecureString -String "{password}" -AsPlainText -Force`
- Prepare a password within an encrypted object

`New-ADUser -Name {username} -AccountPassword $newuser`
- Creates a new AD account and assigns an encrypted password object as it's password

`Enable-ADAccount -Idnetity {username}`
- Enables the target AD account

`Set-ADAccountPassword {username} -NewPassword $newpwd -Reset -PassThru | Set-ADUser -ChangePasswordAtLogon $True`
- Resets the password for the target AD Account and forces the user to change the password at login

`NewADGroup -Name {groupname} -SamAccountName {samaccountname} -GroupCategory {Security/Distribution} -GroupScope {Global/Local/Domain/Universal} -Path {oupath}`
- Create new AD group

`Search-ADAccount -PasswordNeverExpires`
- Search for accounts with non-expiring passwords

`Search-ADAccount -AccountInactive -Timespan 90.00:00:00`
- Search for accounts that haven't signed-on for 90 days

`Search-ADAccount -Lockedout`
- Search for AD accounts in a locked state

`Search-ADAccount -AccountDisabled`
- Search for AD accounts in a disabled state

## ISE Snippets

 ```
 New-IseSnippet -Force -Title "Password_String" -Description "Secure Password String" -Text "`$newpwd = ConvertTo-SecureString -String {password} -AsPlainText -Force
 ```
- Secure password storage object

```
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press and key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
```
- Keeps the console window open upon sucessfull script completion

## DNS Management

`Add-DnsServerPrimaryZone -Name {dnsname} -ReplicationScope {Forest/Domain} -PassThru`
- New DNS primary zone

`Add-DnsServerResourceRecordA -Name {hostname} -ZoneName {dnszonename} -AllowUpdateAny -IPv4Address {ipaddress} -TimeToLive 01:00:00`
- New DNS A record with a one hour time to live

## DHCP Management

`Add-DhcpServerv4Scope -Name {scopename} -StartRange {firstipaddress} -EndRange {lastipaddress} -SubnetMask {subnetmask}`
- Create new DHCP scope

`Add-DhcpServerv4Reservation -ComputerName {hostname}.{domain} -ScopeId {scopeipaddress} -IPAddress {ipaddress} -ClientId {macaddress} -Description {description}`
- Create new ip address reservation

`Set-DhcpServerv4OptionValue -ComputerName {hostname}.{domain} -ScopeId {scopeipaddress} -OptionId 006 -Value {ipaddress}`
- Create a new scope setting (DNS)

`Set-DhcpServerv4OptionValue -ComputerName {hostname}.{domain} -ScopeId {scopeipaddress} -OptionId 003 -Value {ipaddress}`
- Create a new scope setting (Gateway)

## File Server

`New-SmbShare -Name {smbsharename} -Path {path} -FullAccess {domain}\{account\group} -ReadAccess {domain}\{account\group}`
- Create a new fileshare
