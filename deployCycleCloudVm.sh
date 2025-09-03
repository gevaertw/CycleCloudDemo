#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh


# uncomment this to do the one time registration
# echo "Register the required providers, accept the terms and conditions for the Cyclecloud VM"
# az provider register --namespace Microsoft.Network
# az vm image terms accept --publisher azurecyclecloud --offer azure-cyclecloud --plan cyclecloud8-gen2


echo "Deploy Cyclecloud using Bicep."
az deployment group create \
    --name CycleCloudDeployment_CycleCloud \
    --resource-group "$cycleCloudVMRGName" \
    --template-file "./Bicep/cycleCloud.bicep" \
    --parameters \
        location="$location" \
        cycleCloudVMName="$cycleCloudVMName" \
        virtualMachineSize="$cycleCloudVMSize" \
        adminUsername="$adminUsername" \
        adminPassword="$adminPassword" \
        cycleCloudNetworkRGName="$cycleCloudNetworkRGName" \
        cycleCloudVnetName="$cycleCloudVnetName" \
        cycleCloudSubnetName="$cycleCloudSubnetName" \
        HPCCluster01SubnetName="$HPCCluster01SubnetName" \
        HPCCluster02SubnetName="$HPCCluster02SubnetName" \
        HPCCluster03SubnetName="$HPCCluster03SubnetName" \
        HPCCluster04SubnetName="$HPCCluster04SubnetName" \
        cycleCloudLockerStorageAccountName="$cycleCloudLockerStorageAccountName" \
        StorageAccountExceptionIP="$StorageAccountExceptionIP" \
        mgmtVMName="$mgmtVMName"

