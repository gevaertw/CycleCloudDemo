###############################################################################
# Check the parameters file for the correct values before running this script
# See doc for more information on the parameters file
###############################################################################

# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent


# some basic stuff
$baseName = $parametersObj.parameters.baseName.value  
$cycleCloudSubscriptionID = $parametersObj.parameters.cycleCloudSubscriptionID.value        
$location = $parametersObj.parameters.location.value

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


Write-Host -ForegroundColor Green "Select $cycleCloudSubscriptionID for deployment"
az account set --subscription $cycleCloudSubscriptionID

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
        adminPassword=$adminPassword
        costingDBskuName=$costingDBskuName
        costingDBskuTier=$costingDBskuTier


 
# cycleCloudNFSStorageAccountName=$cycleCloudNFSStorageAccountName `
# storageSubnetName=$storageSubnetName `

Write-Host -ForegroundColor Green "Deploy Cyclecloud NFS storage using Bicep."
az deployment group create `
  --name MyDeployment `
  --resource-group $cycleCloudStorageRGName `
  --template-file ./bicep/storage.bicep ` `
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

Write-Host -ForegroundColor Green "Grant the role to the identity of the cyclecloud VM"
$identityId=$(az resource list -n $cycleCloudVMName --query [*].identity.principalId --out tsv)

Write-Host -ForegroundColor Green "Identity Id: $identityId"

Write-Host -ForegroundColor Green "Assign the role to the identity"
az role assignment create `
    --role 'Custom Role - CycleCloud system assigned identity' `
    --assignee-object-id $identityId `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$cycleCloudSubscriptionID"

Write-Host -ForegroundColor Green "Grant the identity access to the storage accounts"
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $identityId `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudVMRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudLockerStorageAccountName"
az role assignment create `
    --role 'Storage Blob Data Contributor' `
    --assignee-object-id $identityId `
    --assignee-principal-type ServicePrincipal `
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudStorageRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudNFSStorageAccountName"

Write-Host -ForegroundColor Green "$(Get-Date -Format 'HH:mm:ss') Deployment complete"
