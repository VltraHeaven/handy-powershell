Import-Module ActiveDirectory

# Pass path to input .csv first
# .csv headers: givenName, surname, emailaddress
$users = $Args[0]

# Pass name of group second
$group = $Args[1]

# Checks for arguments, exit if null
if ($users -eq $null) {
    Write-Output "Usage: Pass the path to the userlist (.csv) and the name of the group to this script (e.g. .\Add-GroupMembership.ps1 C:\userlist.csv 'GroupName')"
    Write-Output "The input '.csv' file must have the following headers (first row entries): givenName, surname, emailaddress"
    exit
    }

if ($group -eq $null) {
    Write-Output "Usage: Pass the name of the group to this script (e.g. .\Add-GroupMembership.ps1 C:\userlist.csv 'GroupName')"
    Write-Output "The input '.csv' file must have the following headers (first row entries): givenName, surname, emailaddress"
    exit
    }

# Check if the group exists
Write-Output "Checking if group exists..."
try {
    Get-ADGroup -Identity $group | Format-Table SamAccountName
    } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Warning "AD group object not found."
    exit
    } catch {
    Write-Warning "AD group object not found."
    exit
    }


# Searches for users in CSV
Write-Output "The following users were found:"
Import-Csv -Path $users |
    ForEach-Object {
        Get-ADUser -Filter "givenName -eq '$($_.givenName)' -and surname -eq '$($_.surname)' -or emailaddress -eq '$($_.emailaddress)'"
        } | Tee-Object -Variable searchresult

$response = read-host "Would you like to add these users to the specificed group? Enter 'a' to abort or any other key to continue."

if ( $response -eq "a" ) {
    return
    }

#Adds found users to specified group
$searchresult | ForEach-Object { 
    Get-ADUser -Filter "SamAccountName -eq '$($_.SamAccountName)'" |
    Add-ADPrincipalGroupMembership -MemberOf $group
    }
