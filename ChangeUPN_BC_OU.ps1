# Define the new UPN suffix
$newUPNSuffix = "@brandcollective.com.au"

# Specify the distinguished name (DN) of the target OU where users' UPNs and email addresses will be updated
$ouDN = "OU=BP Brands,OU=Port Melbourne,OU=Australia,DC=brandcollective,DC=com,DC=au"  # Update this with your actual OU DN

# Get all users from the specified OU
$ouUsers = Get-ADUser -Filter * -SearchBase $ouDN -Properties UserPrincipalName, EmailAddress

# Iterate through each user in the OU
foreach ($adUser in $ouUsers) {
    # Extract the username from the full UPN
    $username = $adUser.UserPrincipalName -replace "@.+$"

    # Display the original UPN before changing the UPN suffix
    Write-Host "Original UPN for $($adUser.givenName): $($adUser.UserPrincipalName)"

    # Construct the new UPN with the specified suffix
    $newUPN = $username + $newUPNSuffix

    # Set the new UPN for the user
    Set-ADUser -Identity $adUser -UserPrincipalName $newUPN
    Write-Host "Changed UPN for $($adUser.SamAccountName) to $newUPN"

    # Construct the new email address with the specified suffix
    $newEmailAddress = $adUser.EmailAddress.Replace("@bondibather.com.au", $newUPNSuffix)

    # Set the new email address for the user
    Set-ADUser -Identity $adUser -EmailAddress $newEmailAddress
    Write-Host "Changed email address for $($adUser.SamAccountName) to $newEmailAddress" 
}
