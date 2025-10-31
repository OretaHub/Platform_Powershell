# Close Outlook if it's running
$process = Get-Process | Where-Object { $_.Name -eq "OUTLOOK" }
if ($process) {
    Write-Output "Closing Outlook process..."
    $process | Stop-Process -Force
    Start-Sleep -Seconds 5
}

# Specify the registry paths
$identitiesPath = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Identity\Identities"
$profilesPath = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Identity\Profiles"
$outlookProfilesPath = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles"

# Function to remove registry entries
function Remove-RegistryEntries($path) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
        Write-Output "Registry entries at $path removed successfully."
    } else {
        Write-Output "Registry path $path not found."
    }
}

# Function to remove Outlook cache files
function Clear-OutlookCache {
    $outlookCachePath = "$env:LocalAppData\Microsoft\Outlook"

    if (Test-Path $outlookCachePath) {
        Remove-Item -Path $outlookCachePath -Recurse -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path $outlookCachePath)) {
            Write-Output "Outlook cache folder $outlookCachePath removed successfully."
        } else {
            Write-Output "Failed to remove Outlook cache folder $outlookCachePath."
        }
    } else {
        Write-Output "Outlook cache folder $outlookCachePath not found."
    }
}


# Function to remove Outlook Profiles and subfolders
function Remove-OutlookProfiles {
    $outlookProfilesPath = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles"

    if (Test-Path $outlookProfilesPath) {
        Remove-Item -Path $outlookProfilesPath -Recurse -Force
        Write-Output "Outlook profiles and subfolders removed successfully."
    } else {
        Write-Output "Outlook profiles path $outlookProfilesPath not found."
    }
}

# Call the function to remove registry entries
Remove-RegistryEntries $identitiesPath
Remove-RegistryEntries $profilesPath

# Call the function to clear Outlook cache
Clear-OutlookCache

# Call the function to remove Outlook Profiles and subfolders
Remove-OutlookProfiles
