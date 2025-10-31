# Define the domain name for filtering
$DomainName = "@bpbrands.com.au"

# Import the Active Directory module
Import-Module ActiveDirectory

# Get the list of users with email addresses matching the specified domain
$Users = Get-ADUser -Filter "mail -like '*$DomainName'" -Properties Name, GivenName, Surname, mail, Enabled | Where-Object { $_.mail -ne $null }

# Display the list in the console
$Users | Format-Table Name, GivenName, SurName, mail, Enabled

# Prepare a file name friendly version of the domain name
$FileNameDomain = $DomainName -replace '[^a-zA-Z0-9]', ''

# Optionally, you can export this list to a CSV file
$CsvPath = "C:\AD_Users_$FileNameDomain.csv"
$Users | Select-Object Name, GivenName, SurName, mail, Enabled | Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "Users with the domain $DomainName have been retrieved and listed. Check the console output or the CSV file at $CsvPath."
