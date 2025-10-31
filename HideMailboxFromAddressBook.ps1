# Define the OU you want to target
$OrganizationalUnit = "OU=Review Australia,OU=Port Melbourne,OU=Australia,DC=brandcollective,DC=com,DC=au"

# Get all remote mailboxes in the specified OU
$Mailboxes = Get-RemoteMailbox -OrganizationalUnit $OrganizationalUnit -ResultSize Unlimited

# Loop through each mailbox and hide it from the address lists
foreach ($Mailbox in $Mailboxes) {
    Set-RemoteMailbox -Identity $Mailbox.Identity -HiddenFromAddressListsEnabled $true
    Write-Output "Mailbox $($Mailbox.DisplayName) has been hidden from address lists."
}

Write-Output "All mailboxes in the OU have been processed."



Get-ADUser -filter * -searchbase “OU=Designworks,OU=Port Melbourne,OU=Australia,DC=brandcollective,DC=com,DC=au” | Set-ADUser -replace @{msExchHideFromAddressLists=$true}



OU=Shared Mailboxes,OU=Review Australia,OU=Port Melbourne,OU=Australia,DC=brandcollective,DC=com,DC=au