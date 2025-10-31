Import-Csv "C:\Users\netrab_a\Documents\BPContacts.csv" | ForEach {
    New-MailContact -Name $_.Name `
                    -Firstname $_.GivenName `
                    -LastName $_.SurName `
                    -ExternalEmailAddress $_.mail `
                    -OrganizationalUnit "onepas.local/ExternalEmails/BP"
}
