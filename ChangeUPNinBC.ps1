# Define the new UPN suffix
$newUPNSuffix = "@bondibather.com.au"

# Define an array of UPNs to update
$userUPNs = @(
    "sourceu3@bondibather.com.au",
    "sourceu4@bondibather.com.au"
)

# Iterate through each UPN
foreach ($userUPN in $userUPNs) {
    # Extract the username from the full UPN
    $username = $userUPN -replace "@.+$"

    # Get the user object from Active Directory
    $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$userUPN'" -Properties UserPrincipalName, EmailAddress

    # Check if the user object is found
    if ($adUser) {
        # Display the original UPN before changing the UPN suffix
        Write-Host "Original UPN for $($adUser.SamAccountName): $($adUser.UserPrincipalName)"

        # Construct the new UPN with the specified suffix
        $newUPN = $username + $newUPNSuffix

        # Set the new UPN for the user
        Set-ADUser -Identity $adUser -UserPrincipalName $newUPN
        Write-Host "Changed UPN for $($adUser.SamAccountName) to $newUPN"

        # Construct the new email address with the specified suffix
        $newEmailAddress = $userUPN.Replace("@bondibather.com.au", $newUPNSuffix)

        # Set the new email address for the user
        Set-ADUser -Identity $adUser -EmailAddress $newEmailAddress
        Write-Host "Changed email address for $($adUser.SamAccountName) to $newEmailAddress"
    } else {
        Write-Warning "User with UPN $userUPN not found in Active Directory."
    }
}
