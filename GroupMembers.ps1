# Define an array of Active Directory group email addresses
$groupEmailAddresses = @(
    "planners@bpbrands.com.au", "dropbox@bpbrands.com.au", "beonic@bpbrands.com.au", "callcentrereports@bpbrands.com.au",
    "rewards-testing@bpbrands.com.au", "BPipad@bpbrands.com.au", "iPad@bpbrands.com.au", "blackpepperallocations@bpbrands.com.au",
    "Breakaway-POS-Price-Variance-Report@bpbrands.com.au", "BlackPepperReturnsReport@bpbrands.com.au"
)

# Initialize an empty array to store group members' details
$groupMembersDetails = @()

# Iterate through each group email address
foreach ($groupEmailAddress in $groupEmailAddresses) {
    # Get the distribution group object based on the email address
    $group = Get-ADGroup -Filter { mail -eq $groupEmailAddress }

    # Check if the distribution group object was found
    if ($group) {
        # Get the members of the distribution group
        $groupMembers = Get-ADGroupMember -Identity $group.DistinguishedName | Where-Object { $_.ObjectClass -eq 'User' }

        # Add group members' details to the array
        $groupMembersDetails += $groupMembers | ForEach-Object {
            $memberUPN = Get-ADUser -Identity $_.DistinguishedName -Properties UserPrincipalName | Select-Object -ExpandProperty UserPrincipalName
            [PSCustomObject]@{
                "Group Name" = $group.Name
                "Member UPN" = $memberUPN
            }
        }
    } else {
        Write-Warning "Distribution list with email address $groupEmailAddress not found."
    }
}

# Export the group members' details to a CSV file
$groupMembersDetails | Export-Csv -Path "C:\GroupMembersDetails.csv" -NoTypeInformation -Encoding UTF8

# Display a message in the console indicating that the export is completed
Write-Host "Export to CSV file 'C:\GroupMembersDetails.csv' completed successfully."
