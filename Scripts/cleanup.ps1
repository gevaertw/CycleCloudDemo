# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent

$cycleCloudSubscriptionID=$parametersObj.parameters.cycleCloudSubscriptionID.value
$cycleCloudVMRGName = $parametersObj.parameters.cycleCloudVMRGName.value
$cycleCloudNetworkRGName = $parametersObj.parameters.cycleCloudNetworkRGName.value

Write-Host -ForegroundColor Green Select the subscription: $cycleCloudSubscriptionID
az account set --subscription $cycleCloudSubscriptionID

az group delete --name $cycleCloudVMRGName --yes #--no-wait
az group delete --name $cycleCloudNetworkRGName --yes #--no-wait