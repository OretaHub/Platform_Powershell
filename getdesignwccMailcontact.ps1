# Define the domain to filter
$domain = "designwcc.com.au"

# Get all mail contacts and filter based on the domain in the email address
$mailContacts = Get-MailContact -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like "*@$domain" }

# Output the result
$mailContacts | Select-Object DisplayName, PrimarySmtpAddress | Format-Table -AutoSize
