# Define the new UPN suffix
$newUPNSuffix = "@pasco.com.au"
$oldUPNSuffix = "@bondibather.com.au"

# Get all user objects with UPNs ending with "bondibather.com.au"
$usersToUpdate = Get-ADUser -Filter "UserPrincipalName -like '*@bondibather.com.au'" -Properties UserPrincipalName, EmailAddress
# Iterate through each user object
foreach ($user in $usersToUpdate) {
    # Display the original UPN before changing the UPN suffix
    Write-Host "Original UPN for $($user.SamAccountName): $($user.UserPrincipalName)"

    # Extract the username from the current UPN
    $username = $user.UserPrincipalName -replace "@.+$"

    # Construct the new UPN with the specified suffix
    $newUPN = $username + $newUPNSuffix

    # Set the new UPN for the user
    Set-ADUser -Identity $user -UserPrincipalName $newUPN
    Write-Host "Changed UPN for $($user.SamAccountName) to $newUPN"

    # Construct the new email address with the specified suffix
    $newEmailAddress = $user.UserPrincipalName.Replace("@bondibather.com.au", $newUPNSuffix)

    # Set the new email address for the user
    Set-ADUser -Identity $user -EmailAddress $newEmailAddress
    Write-Host "Changed email address for $($user.SamAccountName) to $newEmailAddress"
}

Write-Host "UPN and email address updates completed successfully."


# Get all distribution groups with UPNs ending with the old suffix
$distributionGroups = Get-ADGroup -Filter "GroupCategory -eq 'Distribution' -and GroupScope -eq 'Universal'" -Properties UserPrincipalName, EmailAddress |
    Where-Object { $_.UserPrincipalName -like "*$oldUPNSuffix" }

# Iterate through each distribution group and update the UPN suffix
foreach ($group in $distributionGroups) {
    # Get the current UPN and email address of the group
    $currentUPN = $group.UserPrincipalName
    $currentEmail = $group.EmailAddress

    # Replace the old UPN suffix with the new UPN suffix
    $newUPN = $currentUPN.Replace($oldUPNSuffix, $newUPNSuffix)

    # Update the UPN and email address for the group
    Set-ADGroup -Identity $group -UserPrincipalName $newUPN -EmailAddress $newUPN
    Write-Host "Changed UPN and email address for group $($group.Name) to $newUPN"
}

Write-Host "UPN suffix updates for distribution groups completed successfully."
