#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh

echo "Deploy Cyclecloud NFS storage using Bicep."
az deployment group create \
    --name MyDeployment \
    --resource-group "$cycleCloudStorageRGName" \
    --template-file "./Bicep/storage.bicep" \
    --parameters \
        location="$location" \
        cycleCloudNetworkRGName="$cycleCloudNetworkRGName" \
        cycleCloudVnetName="$cycleCloudVnetName" \
        cycleCloudSubnetName="$cycleCloudSubnetName" \
        storageSubnetName="$storageSubnetName" \
        HPCCluster01SubnetName="$HPCCluster01SubnetName" \
        HPCCluster02SubnetName="$HPCCluster02SubnetName" \
        HPCCluster03SubnetName="$HPCCluster03SubnetName" \
        HPCCluster04SubnetName="$HPCCluster04SubnetName" \
        StorageAccountExceptionIP="$StorageAccountExceptionIP" \
        cycleCloudNFSStorageAccountName="$cycleCloudNFSStorageAccountName"

echo "Create the custom role."
az deployment sub create \
    --name MyCycleCloudRoleDeployment \
    --template-file "./Bicep/cyclecloudRole.bicep" \
    --location "$location"

# Create service principal and assign roles
sp_json=$(az ad sp create-for-rbac --name "$cycleCloudServicePrincipalName" --years 1 --role "Custom Role - CycleCloud system assigned identity" --scopes "/subscriptions/$cycleCloudSubscriptionID")
sp_appId=$(echo "$sp_json" | jq -r '.appId')
sp_password=$(echo "$sp_json" | jq -r '.password')
sp_tenant=$(echo "$sp_json" | jq -r '.tenant')

# Grant the identity access to the storage accounts
echo "Grant the identity access to the storage accounts"
az role assignment create \
    --role 'Storage Blob Data Contributor' \
    --assignee-object-id "$sp_appId" \
    --assignee-principal-type ServicePrincipal \
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudVMRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudLockerStorageAccountName"
az role assignment create \
    --role 'Storage Blob Data Contributor' \
    --assignee-object-id "$sp_appId" \
    --assignee-principal-type ServicePrincipal \
    --scope "/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudStorageRGName/providers/Microsoft.Storage/storageAccounts/$cycleCloudNFSStorageAccountName"

echo "$(date +'%H:%M:%S') Deployment complete take note of these values:"
echo "Cyclecloud service principal: $sp_appId"
echo "Cyclecloud service principal password: $sp_password"
echo "Cyclecloud service principal tenant: $sp_tenant"
