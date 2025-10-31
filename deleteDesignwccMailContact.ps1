# Define the domain to filter
$domain = "designwcc.com.au"

# Get all mail contacts and filter based on the domain in the email address
$mailContacts = Get-MailContact -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like "*@$domain" }

# Confirm before deleting each contact
foreach ($contact in $mailContacts) {
    Write-Host "Deleting contact:" $contact.DisplayName "with email" $contact.PrimarySmtpAddress
    Remove-MailContact -Identity $contact.DistinguishedName -Confirm:$true
}

# Optionally, if you want to delete without confirmation, replace the Remove-MailContact line with:
# Remove-MailContact -Identity $contact.DistinguishedName -Confirm:$false
