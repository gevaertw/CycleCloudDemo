###############################################################################
# Check the parameters file for the correct values before running this script
# See doc for more information on the parameters file
###############################################################################

# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent


# Some basic stuff
$baseName = $parametersObj.parameters.baseName.value
$cycleCloudTenantID = $parametersObj.parameters.cycleCloudTenantID.value  
$cycleCloudSubscriptionID = $parametersObj.parameters.cycleCloudSubscriptionID.value        
$location = $parametersObj.parameters.location.value
$cycleCloudServicePrincipalName = $parametersObj.parameters.cycleCloudServicePrincipalName.value

# Resource Group Names                                       
$cycleCloudNetworkRGName = $parametersObj.parameters.cycleCloudNetworkRGName.value         
$cycleCloudVMRGName = $parametersObj.parameters.cycleCloudVMRGName.value                                   
$cycleCloudStorageRGName = $parametersObj.parameters.cycleCloudStorageRGName.value                                        
$cycleCloudCostingRGName = $parametersObj.parameters.cycleCloudCostingRGName.value    
$cycleCloudMonitoringRGName = $parametersObj.parameters.cycleCloudMonitoringRGName.value                                    

# VM settings
$adminUsername = $parametersObj.parameters.adminusername.value                             
$adminPassword = $parametersObj.parameters.adminPassword.value                                
$mgmtVMName = $parametersObj.parameters.mgmtVMName.value

# Network settings                              
$cycleCloudVnetName = $parametersObj.parameters.cycleCloudVnetName.value                    
$addressPrefixes = $parametersObj.parameters.addressPrefixes.value                          
$cycleCloudSubnetName = $parametersObj.parameters.cycleCloudSubnetName.value                
$cyclecloudSubnetPrefix = $parametersObj.parameters.cyclecloudSubnetPrefix.value           
$storageSubnetName = $parametersObj.parameters.storageSubnetName.value                      
$storageSubnetPrefix = $parametersObj.parameters.storageSubnetPrefix.value
$bastionSubnetPrefix = $parametersObj.parameters.bastionSubnetPrefix.value
$HPCCluster01SubnetName = $parametersObj.parameters.HPCCluster01SubnetName.value
$HPCCluster01SubnetPrefix = $parametersObj.parameters.HPCCluster01SubnetPrefix.value
$HPCCluster02SubnetName = $parametersObj.parameters.HPCCluster02SubnetName.value
$HPCCluster02SubnetPrefix = $parametersObj.parameters.HPCCluster02SubnetPrefix.value
$HPCCluster03SubnetName = $parametersObj.parameters.HPCCluster03SubnetName.value
$HPCCluster03SubnetPrefix = $parametersObj.parameters.HPCCluster03SubnetPrefix.value
$HPCCluster04SubnetName = $parametersObj.parameters.HPCCluster04SubnetName.value
$HPCCluster04SubnetPrefix = $parametersObj.parameters.HPCCluster04SubnetPrefix.value

# Cyclecloud settings
$cycleCloudVMName = $parametersObj.parameters.cycleCloudVMName.value
$cycleCloudVMSize = $parametersObj.parameters.cycleCloudVMSize.value     
$cycleCloudLockerStorageAccountName = $parametersObj.parameters.cycleCloudLockerStorageAccountName.value

# Storage account NFS settings
$cycleCloudNFSStorageAccountName = $parametersObj.parameters.cycleCloudNFSStorageAccountName.value
$StorageAccountExceptionIP = $parametersObj.parameters.StorageAccountExceptionIP.value

# Costing database settings
$costingDBSeverName = $parametersObj.parameters.costingDBSeverName.value
$costingDBName = $parametersObj.parameters.costingDBName.value
$costingDBskuName = $parametersObj.parameters.costingDBskuName.value
$costingDBskuTier = $parametersObj.parameters.costingDBskuTier.value

# Monitoring settings
$monitoringUserAssignedIdentityName = $parametersObj.parameters.monitoringUserAssignedIdentityName.value
$monitoringGrafanaName = $parametersObj.parameters.monitoringGrafanaName.value
$monitoringPrometheusName = $parametersObj.parameters.monitoringPrometheusName.value


Write-Host -ForegroundColor Green "Select $cycleCloudSubscriptionID for deployment in tenant $cycleCloudTenantID"
az login --tenant $cycleCloudTenantID
az account set --subscription $cycleCloudSubscriptionID

# This is do be done only once per subscription, if you have done this before you can comment this step out (it does not hurt to run it again, its just not needed)
Write-Host -ForegroundColor Green "Register the required providers, accept the terms and conditions for the Cyclecloud VM"
az provider register --namespace Microsoft.Network
az vm image terms accept --publisher azurecyclecloud --offer azure-cyclecloud --plan cyclecloud8-gen2
# End only once steps

Write-Host -ForegroundColor Green Deploy the Azure Resource Groups using Bicep.
az deployment sub create `
    --name CycleCloudDeployment_RGs `
    --location $location `
    --template-file ./bicep/resourceGroups.bicep `
    --parameters `
        cycleCloudVMRGName=$cycleCloudVMRGName `
        cycleCloudNetworkRGName=$cycleCloudNetworkRGName `
        cycleCloudStorageRGName=$cycleCloudStorageRGName `
        cycleCloudCostingRGName=$cycleCloudCostingRGName `
        cycleCloudMonitoringRGName=$cycleCloudMonitoringRGName `
        location=$location

# in case you have the network predefined, you can skip the network deployment, just make sure to fill in the parameter file with the correct values
Write-Host -ForegroundColor Green Deploy the network using Bicep.
az deployment group create `
    --name CycleCloudDeployment_Network `
    --resource-group $cycleCloudNetworkRGName `
    --template-file ./bicep/network.bicep `
    --parameters `
        baseName=$baseName `
        location=$location `
        cycleCloudSubnetName=$cycleCloudSubnetName `
        cycleCloudVnetName=$cycleCloudVnetName `
        addressPrefixes=$addressPrefixes `
        cyclecloudSubnetPrefix=$cyclecloudSubnetPrefix `
        storageSubnetName=$storageSubnetName `
        storageSubnetPrefix=$storageSubnetPrefix `
        bastionSubnetPrefix=$bastionSubnetPrefix `
        HPCCluster01SubnetName=$HPCCluster01SubnetName `
        HPCCluster01SubnetPrefix=$HPCCluster01SubnetPrefix `
        HPCCluster02SubnetName=$HPCCluster02SubnetName `
        HPCCluster02SubnetPrefix=$HPCCluster02SubnetPrefix `
        HPCCluster03SubnetName=$HPCCluster03SubnetName `
        HPCCluster03SubnetPrefix=$HPCCluster03SubnetPrefix `
        HPCCluster04SubnetName=$HPCCluster04SubnetName `
        HPCCluster04SubnetPrefix=$HPCCluster04SubnetPrefix

# At some point the NSG's should be split out here, but for now they are in the network.bicep file


Write-Host -ForegroundColor Green "Deploy Cyclecloud using Bicep."
az deployment group create `
    --name CycleCloudDeployment_CycleCloud `
    --resource-group $cycleCloudVMRGName `
    --template-file ./bicep/cycleCloud.bicep `
    --parameters `
        location=$location `
        cycleCloudVMName=$cycleCloudVMName `
        virtualMachineSize=$cycleCloudVMSize `
        adminUsername=$adminUsername `
        adminPassword=$adminPassword `
        cycleCloudNetworkRGName=$cycleCloudNetworkRGName `
        cycleCloudVnetName=$cycleCloudVnetName `
        cycleCloudSubnetName=$cycleCloudSubnetName `
        HPCCluster01SubnetName=$HPCCluster01SubnetName `
        HPCCluster02SubnetName=$HPCCluster02SubnetName `
        HPCCluster03SubnetName=$HPCCluster03SubnetName `
        HPCCluster04SubnetName=$HPCCluster04SubnetName `
        cycleCloudLockerStorageAccountName=$cycleCloudLockerStorageAccountName `
        StorageAccountExceptionIP=$StorageAccountExceptionIP `
        mgmtVMName=$mgmtVMName


# Costing database
Write-Host -ForegroundColor Green "Deploy Cyclecloud costing database using Bicep."
az deployment group create `
    --name CycleCloudDeployment_CycleCloud `
    --resource-group $cycleCloudCostingRGName `
    --template-file ./bicep/cycleCloudCosting.bicep `
    --parameters `
        location=$location `
        cycleCloudNetworkRGName=$cycleCloudNetworkRGName `
        cycleCloudVnetName=$cycleCloudVnetName `
        cycleCloudSubnetName=$cycleCloudSubnetName `
        costingDBSeverName=$costingDBSeverName `
        costingDBName=$costingDBName `
        adminPassword=$adminPassword `
        costingDBskuName=$costingDBskuName `
        costingDBskuTier=$costingDBskuTier


Write-Host -ForegroundColor Green "Deploy Cyclecloud NFS storage using Bicep."
az deployment group create `
  --name MyDeployment `
  --resource-group $cycleCloudStorageRGName `
  --template-file ./bicep/storage.bicep `
  --parameters `
        location=$location `
        cycleCloudNetworkRGName=$cycleCloudNetworkRGName `
        cycleCloudVnetName=$cycleCloudVnetName `
        cycleCloudSubnetName=$cycleCloudSubnetName `
        storageSubnetName=$storageSubnetName `
        HPCCluster01SubnetName=$HPCCluster01SubnetName `
        HPCCluster02SubnetName=$HPCCluster02SubnetName `
        HPCCluster03SubnetName=$HPCCluster03SubnetName `
        HPCCluster04SubnetName=$HPCCluster04SubnetName `
        StorageAccountExceptionIP=$StorageAccountExceptionIP `
        cycleCloudNFSStorageAccountName=$cycleCloudNFSStorageAccountName

Write-Host -ForegroundColor Green "Create the custom role."
    az deployment sub create `
    --name MyCycleCloudRoleDeployment `
    --template-file ./Bicep/cyclecloudRole.bicep `
    --location $location

$servicePrincipal = az ad sp create-for-rbac --name $cycleCloudServicePrincipalName --years 1 --role "Custom Role - CycleCloud system assigned identity" --scopes "/subscriptions/$cycleCloudSubscriptionID" | ConvertFrom-Json

# ---this section is probably no longer needed as it assume the VM identity is used..., but I will leave it here for now
# Write-Host -ForegroundColor Green "Grant the role to the identity of the cyclecloud VM"
# $CycleVMIdentityId=$(az resource list -n $cycleCloudVMName --query [*].identity.principalId --out tsv)
# $identityId=$(az ad sp show --id $cycleCloudVMName --query objectId --out tsv)


# Write-Host -ForegroundColor Green "Identity Id: $CycleVMIdentityId"
<# 
Write-Host -ForegroundColor Green "Assign the role to the identity"
az role assignment create `
   --role 'Custom Role - CycleCloud system assigned identity' `
   --assignee-object-id $CycleVMIdentityId `
   --assignee-principal-type ServicePrincipal `
   --scope "/subscriptions/$cycleCloudSubscriptionID"
 #>

Write-Host -ForegroundColor Green "Grant the identity access to the storage accounts"
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $servicePrincipal.appId `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudVMRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudLockerStorageAccountName"
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $servicePrincipal.appId `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudStorageRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudNFSStorageAccountName"

# Monitoring

# WIP this is not correct / tested yet
# az policy definition create --name "vmssUserAssignedIdentityPolicy" --display-name "VMSS User Assigned Identity Policy" --description "Ensure VMSS have user assigned identity for Moneo monitoring" --rules vmssUserAssignedIdentityPolicy.json --mode Indexed 
# az policy assignment create --name "vmssUserAssignedIdentityPolicyAssignment" --policy "vmssUserAssignedIdentityPolicy" --scope "/subscriptions/$cycleCloudSubscriptionID" --params "{ \"userAssignedIdentities\": { \"value\": \"/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudMonitoringRGName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$monitoringUserAssignedIdentityName\" } }"

Write-Host -ForegroundColor Green "$(Get-Date -Format 'HH:mm:ss') Deployment complete take note of these values:"
# Write-Host -ForegroundColor Cyan "Moneo managed identity: $cycleCloudVMName"
Write-Host -ForegroundColor Cyan "Cyclecloud service principal: " $servicePrincipal.appId
Write-Host -ForegroundColor Cyan "Cyclecloud service principal password: " $servicePrincipal.password
Write-Host -ForegroundColor Cyan "Cyclecloud service principal tenant: " $servicePrincipal.tenant


# Can I do something with this error, it seems a one time thing per subscription.. Low prio
# The client 'f6821cb6-ad47-4d07-b73c-1a54509af107' with object id 'f6821cb6-ad47-4d07-b73c-1a54509af107' does not have authorization to perform action 'Microsoft.MarketplaceOrdering/offerTypes/publishers/offers/plans/agreements/write' over scope '/sub