# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName dev@tus.com.au -ShowProgress $true

# Define the domain to filter by
$DomainFilter = "*@tus.com.au"

# Retrieve and display UPN, mailbox size, and mailbox type for mailboxes in the specified domain
$Mailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object {$_.PrimarySmtpAddress -like $DomainFilter} | Get-MailboxStatistics | Select-Object DisplayName, @{name="UPN";expression={(Get-Mailbox $_.DisplayName).UserPrincipalName}}, TotalItemSize, @{name="MailboxType";expression={(Get-Mailbox $_.DisplayName).RecipientTypeDetails}}

$Mailboxes | Format-Table DisplayName, UPN, TotalItemSize, MailboxType

# Optionally, export the information to a CSV file
$Mailboxes | Export-Csv -Path "C:\ExchangeOnline_Mailboxes_design.csv" -NoTypeInformation

# Disconnect from Exchange Online
#Disconnect-ExchangeOnline -Confirm:$false
