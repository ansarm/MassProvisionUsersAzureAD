$userFile = ".\users.csv"
$TargetUPNSuffix = "@ldapeditor.net"
$defaultPassword = "17May1977!"

#Provision count max is 50000
$ProvisionCount = 50

Import-Module AzureADPreview

Function ImportUser($user)
{
    $displayName = $user.GivenName + " " + $user.Surname
    $username = $user.GivenName+ $user.Surname
    $userprincipalname = $username+$TargetUPNSuffix
    $securepass =  ConvertTo-SecureString -string $defaultPassword -Force -AsPlainText
    Write-Host "Creating User " + $displayName
    New-ADUser -EMail $userprincipalname -Name $displayName -Path $TargetContainer -State $_.State -Enabled $true -GivenName $_.GivenName -Surname $_.Surname -Country $_.Country -POBox $_.Zipcode -DisplayName $displayName -UserPrincipalName $userprincipalname -AccountPassword $securepass -SamAccountName $username

}

Connect-AzureAD -Credential (get-credential)

$users = Import-Csv -Path $userFile
$users[0..$ProvisionCount] | ForEach-Object { ImportUser $_ }