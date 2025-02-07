# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent

$cycleCloudSubscriptionID=$parametersObj.parameters.cycleCloudSubscriptionID.value
$cycleCloudVMRGName = $parametersObj.parameters.cycleCloudVMRGName.value
$cycleCloudNetworkRGName = $parametersObj.parameters.cycleCloudNetworkRGName.value
$cycleCloudStorageRGName = $parametersObj.parameters.cycleCloudStorageRGName.value
$cycleCloudCostingRGName = $parametersObj.parameters.cycleCloudCostingRGName.value
$cycleCloudMonitoringRGName = $parametersObj.parameters.cycleCloudMonitoringRGName.value

Write-Host -ForegroundColor Green Select the subscription: $cycleCloudSubscriptionID
az account set --subscription $cycleCloudSubscriptionID

# Delete the resource groups, wacht for dependencies, network is last.
az group delete --name $cycleCloudVMRGName --yes #--no-wait
az group delete --name $cycleCloudStorageRGName --yes #--no-wait
az group delete --name $cycleCloudCostingRGName --yes #--no-wait
az group delete --name $cycleCloudMonitoringRGName --yes #--no-wait
az group delete --name $cycleCloudNetworkRGName --yes #--no-wait
