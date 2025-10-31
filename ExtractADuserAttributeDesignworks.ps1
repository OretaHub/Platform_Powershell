# Import the Active Directory module
Import-Module ActiveDirectory

# Define the path to the input CSV file
$inputCsvPath = "C:\Users\netrab_a\Documents\User Creation\input_upns.csv"

# Import the CSV file
$upns = Import-Csv -Path $inputCsvPath

# Define the attributes to retrieve
$attributes = @(
    "DisplayName", "GivenName", "Surname", "Title", "Department", "Company",
    "MobilePhone", "StreetAddress", "City", "State", "PostalCode", "Country",
    "TelephoneNumber", "Enabled", "HomeDirectory", "SamAccountName", "EmailAddress", "UserPrincipalName"
)

# Initialize an empty array to hold the user details
$userDetails = @()

# Loop through each UPN and retrieve the user details
foreach ($upn in $upns) {
    $user = Get-ADUser -Filter "mail -eq '$($upn.Mail)'" -Properties $attributes
    if ($user) {
        $userDetails += $user
    }
}

# Define the output CSV file path
$outputCsvPath = "C:\Users\netrab_a\Documents\User Creation\ad_users_details.csv"

# Export the user details to the CSV file
$userDetails | Select-Object $attributes | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "User details exported to $outputCsvPath"
