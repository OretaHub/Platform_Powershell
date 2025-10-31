# Path to the CSV file
$csvFilePath = "C:\Users\netrab_a\Documents\Designwcc\ad_users_details.csv"

# Retrieve the user UPNs and folder paths from the CSV file
$userFolders = Import-Csv -Path $csvFilePath

# Domain controller for the brandcollective.com.au domain
$domainController = "PM-AD-1.brandcollective.com.au"

foreach ($userFolder in $userFolders) {
    $userUPN = $userFolder.UserPrincipalName
    $folderPath = $userFolder.HomeDirectory

    # Retrieve the user account from the brandcollective.com.au domain
    $user = Get-ADUser -Server $domainController -Filter {UserPrincipalName -eq $userUPN}

    if ($null -ne $user) {
        # Define the user's domain\username
        $userDomainUsername = "$($user.SamAccountName)@$($user.UserPrincipalName.Split('@')[1])"
        
        # Grant full access to the specified folder
        try {
            $acl = Get-Acl -Path $folderPath
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($userDomainUsername, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
            $acl.SetAccessRule($accessRule)
            Set-Acl -Path $folderPath -AclObject $acl
            Write-Output "Granted full access to $userUPN for folder $folderPath"
        } catch {
            Write-Output "Failed to set permissions for $userUPN on folder $folderPath. Error: $_"
        }
    } else {
        Write-Output "User with UPN $userUPN not found in the brandcollective.com.au domain"
    }
}

Write-Output "Access update process completed."
