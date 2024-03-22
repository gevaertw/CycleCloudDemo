# check the parameters file for the correct values before running this script
# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './Bicep/CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent

$location = $parametersObj.parameters.location.value
Write-Host -ForegroundColor Green "Location: $location"
$cycleCloudVMName = $parametersObj.parameters.cycleCloudVMName.value
Write-Host -ForegroundColor Green "CycleCloud VM Name: $cycleCloudVMName"
$cycleCloudVMRGName = $parametersObj.parameters.cycleCloudVMRGName.value
Write-Host -ForegroundColor Green "CycleCloud VM Resource Group Name: $cycleCloudVMRGName"
$managementSubscriptionID=$(az account show --query id --output tsv)
Write-Host -ForegroundColor Green "Management Subscription ID: $managementSubscriptionID"
$cycleCloudLockerStorageAccountName = $parametersObj.parameters.cycleCloudLockerStorageAccountName.value
Write-Host -ForegroundColor Green "CycleCloud Storage Account Name: $cycleCloudLockerStorageAccountName"
$cycleCloudNFSStorageAccountName = $parametersObj.parameters.cycleCloudNFSStorageAccountName.value
Write-Host -ForegroundColor Green "CycleCloud Storage Account Name: $cycleCloudNFSStorageAccountName"

Set-Location ./Bicep
Write-Host -ForegroundColor Green Deploy the Azure resources using Bicep
az deployment sub create `
    --name MyCycleCloudDeployment `
    --template-file ./main.bicep `
    --location $location `
    --parameters '@CycleCloudParameters.json'
Write-Host -ForegroundColor Green create the custom role
    az deployment sub create `
    --name MyCycleCloudRoleDeployment `
    --template-file ./cyclecloudRole.bicep `
    --location $location
Set-Location ..


Write-Host -ForegroundColor Green grant the role to the identity of the cyclecloud VM
$identityId=$(az resource list -n $cycleCloudVMName --query [*].identity.principalId --out tsv)
Write-Host -ForegroundColor Green "Identity Id: $identityId"
Write-Host -ForegroundColor Green Assign the role to the identity
az role assignment create `
    --role 'Custom Role - CycleCloud system assigned identity' `
    --assignee-object-id $identityId  `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$managementSubscriptionID"
Write-Host -ForegroundColor Green Grant the identity access to the storage accounts
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $identityId  `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$managementSubscriptionID/resourceGroups/$cycleCloudVMRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudLockerStorageAccountName"
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $identityId  `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$managementSubscriptionID/resourceGroups/$cycleCloudVMRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudNFSStorageAccountName"