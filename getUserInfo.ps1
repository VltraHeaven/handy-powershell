Import-Module ActiveDirectory

# input|outfile path arguments
$userlist = $Args[0] 
$outfile = $Args[1]

# Checks for arguments, exit if null
if ($userlist -eq $null) {
    Write-Output "Usage: Pass the path of the input and output files (.csv) to this script (e.g. .\Onboard_Search.ps1 C:\userlist.csv new-userlist.csv)"
    Write-Output "The input '.csv' file must have the following headers (first row entries): givenName, surname"
    Write-Output "The output '.csv' file will include the following information: givenName, surname, emailAddress, SamAccountName"
    exit
    }

if ($outfile -eq $null) {
    Write-Output "Usage: Pass the name of the desired output file (.csv) to this script (e.g. .\Onboard_Search.ps1 C:\userlist.csv new-userlist.csv)"
    Write-Output "The input '.csv' file must have the following headers (first row entries): givenName, surname"
    Write-Output "The output '.csv' file will include the following information: givenName, surname, emailAddress, SamAccountName"
    exit
    }

# Search for each entry in AD and output results to outfile
Import-Csv -Path $userlist |
ForEach-Object {
    Get-ADUser -Filter "givenName -eq '$($_.givenName)' -and surname -eq '$($_.surname)'" -Properties EmployeeNumber,Mail,emailAddress,givenName,surname
    } |
    Select-Object givenName, surname, emailAddress, SamAccountName | Export-Csv $outfile -NoTypeInformation
