param (
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName
)

# Import the Exchange Online PowerShell Module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online PowerShell
Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName

# Get all shared mailboxes
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

# Display all shared mailboxes and allow selection
$SelectedMailboxes = $SharedMailboxes | Out-GridView -Title "Select Shared Mailboxes" -PassThru

# Get all users
$AllUsers = Get-Mailbox -ResultSize Unlimited

# Display all users and allow selection
$SelectedUsers = $AllUsers | Out-GridView -Title "Select Users" -PassThru

# Add selected users to selected mailboxes
foreach ($mailbox in $SelectedMailboxes) {
    foreach ($user in $SelectedUsers) {
        Add-MailboxPermission -Identity $mailbox.DistinguishedName -User $user.UserPrincipalName -AccessRights FullAccess -InheritanceType All
    }
}

# Disconnect the Exchange Online PowerShell session
Disconnect-ExchangeOnline -Confirm:$false
