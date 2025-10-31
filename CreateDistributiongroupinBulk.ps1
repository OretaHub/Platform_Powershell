# Specify the path to the CSV file
$csvPath = "C:\Users\nb_admin\Documents\Review-Australia\review-distributionlists.csv"

# Import the CSV file
$groupDetails = Import-Csv -Path $csvPath

# Specify the OU where the groups should be created
$organizationalUnit = "OU=Review-DistributionGroups,OU=Review Australia,OU=Port Melbourne,OU=Australia,DC=brandcollective,DC=com,DC=au"

# Loop through each entry in the CSV and create the distribution group
foreach ($group in $groupDetails) {
    try {
        # Create the distribution group
        $newGroup = New-DistributionGroup -Name $group.Name `
                                          -OrganizationalUnit $organizationalUnit `
                                          -PrimarySmtpAddress $group.SMTPAddress `
                                          -ErrorAction Stop

        # Output the result
        Write-Output "Distribution Group `'$($group.Name)`' with SMTP `'$($group.SMTPAddress)`' created successfully."
    } catch {
        Write-Output "Error creating group `'$($group.Name)`': $_"
    }
}
