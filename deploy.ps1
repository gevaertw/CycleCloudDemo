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

# Deploy the Azure resources using Bicep
cd ./Bicep
az deployment sub create `
    --name MyCycleCloudRoleDeployment `
    --template-file ./cyclecloudRole.bicep `
    --location $location
az deployment sub create `
    --name MyCycleCloudDeployment `
    --template-file ./main.bicep `
    --location $location `
    --parameters '@CycleCloudParameters.json'
cd ..

# grant the role to the identity of the cyclecloud VM
$identityId=$(az resource list -n $cycleCloudVMName --query [*].identity.principalId --out tsv)
Write-Host -ForegroundColor Green -ForegroundColor Green "Identity Id: $identityId"
# assign the role to the identity
az role assignment create `
    --role 'Custom Role - CycleCloud system assigned identity' `
    --assignee-object-id $identityId  `
    --scope "/subscriptions/$managementSubscriptionID"