$userFile = ".\users.csv"
$TargetUPNSuffix = "@contoso.com"
$defaultPassword = "P@ssword2!"

#Provision count max is 50000
$ProvisionCount = 50
1ew
Import-Module AzureADPreview
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.password = $defaultPassword
$PasswordProfile.ForceChangePasswordNextLogin = $false


Function ImportUser($user)
{
    $displayName = $user.GivenName + " " + $user.Surname
    $username = $user.GivenName+ $user.Surname
    $userprincipalname = $username+$TargetUPNSuffix
    $securepass =  ConvertTo-SecureString -string $defaultPassword -Force -AsPlainText
    Write-Host "Creating User " + $displayName
    New-AzureADUser -DisplayName $displayName -PasswordProfile $PasswordProfile -UserPrincipalName $userprincipalname  `
            -AccountEnabled $true -MailNickName $username -City $_.city -CompanyName $_.company -Country $_.country -Department $_.department `
            -GivenName $_.GivenName -JobTitle $_.Title  -mobile $_.TelephoneNumber -PostalCode $_.ZipCode  -State $_.State -Surname $_.Surname 
            
}

Connect-AzureAD -Credential (get-credential)


$users = Import-Csv -Path $userFile
$users[0..$ProvisionCount] | ForEach-Object { ImportUser $_ }
