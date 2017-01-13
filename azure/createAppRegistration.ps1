Param(
	[string]$appName,
	[string]$secret
)

$user = Login-AzureRmAccount
$accountId = $user.Context.Account.Id
if (!$user) {
	Write-Host "Login to Azure has failed"
} else {
	Write-Host "You have been logged into Azure as $accountId"
}

$app = Get-AzureRmADApplication -DisplayName $appName

if (!$app){
	Write-Host "This AD Application does not exist so a new AD Application, AD Service Principal and Role Assignment are being created..."
	$appName = if (!$appName) { "dev-$env.USERNAME" } else { $appName }
	$app = New-AzureRmADApplication -DisplayName $appName -HomePage "https://$appName" -IdentifierUris "https://$appName" -Password $secret
	New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId
	New-AzureRmRoleAssignment -RoleDefinitionName "Owner" -ServicePrincipalName $app.ApplicationId.Guid
	Write-Host "New AD Application, AD Service Principal and Role Assignment have been created."
} else {
	Write-Host "This AD Application already exists, the password for this application is being updated with the secret provided."
	$credential = New-AzureRmADAppCredential -ObjectId $app.ObjectId -Password $secret
	Write-Host "Password updated."
}

$subscription = Get-AzureRmSubscription
$armObjectId = (Get-AzureRmRoleAssignment | Where-Object {$_.DisplayName -eq $appName}).ObjectId
$tenantId = $subscription.TenantId

Write-Host "Saving the following environment variables:"
Write-Host "	ARM_SUBSCRIPTION_ID"
setx ARM_SUBSCRIPTION_ID $subscription.SubscriptionId >$null 2>&1
Write-Host "	ARM_CLIENT_ID"
setx ARM_CLIENT_ID $app.ApplicationId.Guid >$null 2>&1
Write-Host "	ARM_CLIENT_SECRET"
setx ARM_CLIENT_SECRET $secret >$null 2>&1
Write-Host "	ARM_TENANT_ID"
setx ARM_TENANT_ID $tenantId >$null 2>&1
Write-Host "	ARM_OBJECT_ID"
setx ARM_OBJECT_ID $armObjectId >$null 2>&1

Write-Host "App Registration Complete"
