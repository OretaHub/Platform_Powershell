# Import Active Directory module for running AD cmdlets
Import-Module ActiveDirectory

# Store the data from your CSV file in the $ADUsers variable
$ADUsers = Import-csv "C:\Users\nb_admin\Documents\GOLDENCSV.csv"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {
    # Read user data from each field in each row and assign the data to variables
    $Username = $User.SAM
    $Password = $User.Password
    $Firstname = $User.Firstname
    $Lastname = $User.Lastname
    $OU = $User.OU
    $Email = $User.Email
    $HomeDirectory = $User.HomeDirectory

    # Check to see if the user already exists in AD
    if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
        # If the user does exist, give a warning
        Write-Warning "A user account with username $Username already exists in Active Directory."
    } else {
        # User does not exist, proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@brandcollective.com.au" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Firstname $Lastname" `
            -Path $OU `
            -EmailAddress $Email `
            -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
            -Title $User.JobTitle `
            -Department $User.Department `
            -OfficePhone $User.TelephoneNumber `
            -StreetAddress $User.Street `
            -Country $User.Country `
            -HomeDrive "H:" `
            -HomeDirectory $HomeDirectory
        # You can include additional attributes as needed
    }
}
