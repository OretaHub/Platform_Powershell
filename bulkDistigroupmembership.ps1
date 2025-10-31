# Define the path to the CSV file
$csvPath = "C:\Users\nb_admin\Documents\Designwcc\disti.csv"

# Import the CSV file
$usersData = Import-Csv -Path $csvPath

# Loop through each entry in the CSV file
foreach ($entry in $usersData) {
    $userEmail = $entry.User
    $groupName = $entry.Group
    $groupEmail = $entry.GroupEmail

    #Write-Host "Processing: UserEmail=$userEmail, GroupName=$groupName, GroupEmail=$groupEmail"

    # Search for the group in the specified domain
    $group = Get-ADGroup -Filter "Name -eq '$groupName'"

    if ($group) {
        #Write-Host "Found group: $($group.Name)"

        # Search for the user in the specified domain by email address
        $user = Get-ADUser -Filter "mail -eq '$userEmail'"

        if ($user) {
            #Write-Host "Found user: $($user.SamAccountName)"

            # Check if the user is already a member of the group
            $isMember = Get-ADGroupMember -Identity $group -Recursive | Where-Object { $_.DistinguishedName -eq $user.DistinguishedName }

            if ($isMember) {
                Write-Host "$($user.SamAccountName) is already a member of $($group.Name)"
            } else {
                # Add the user to the found group
                try {
                    Add-ADGroupMember -Identity $group -Members $user
                    Write-Host "Successfully added $($user.SamAccountName) to $($group.Name)"
                } catch {
                    Write-Host "Failed to add $($user.SamAccountName) to $($group.Name): $_"
                }
            }
        } else {
            Write-Host "User with email $userEmail not found in $domain domain"
        }
    } else {
        Write-Host "Group $groupName not found in $domain domain"
    }
}
