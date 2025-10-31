$params = @{
	accountEnabled = $false
}
Get-Content "C:\Users\nbasyal\Documents\file.csv" | ForEach {Update-MgUser -DisplayName $_ -BodyParameter $params}$params = @{
    accountEnabled = $false
}

# Path to the file
$filePath = "C:\Users\nbasyal\Documents\file.csv"

# Read the file content
$displayNames = Get-Content -Path $filePath

foreach ($displayName in $displayNames) {
    try {
        # Get the user object by display name
        $user = Get-MgUser -Filter "displayName eq '$displayName'"
        
        # Check if a user was found
        if ($user) {
            # Update the user
            Update-MgUser -UserId $user.Id -BodyParameter $params
            Write-Host "Account disabled for user: $displayName"
        } else {
            Write-Host "No user found with display name: $displayName"
        }
    } catch {
        Write-Host "Failed to update user: $displayName. Error: $_"
    }
}
