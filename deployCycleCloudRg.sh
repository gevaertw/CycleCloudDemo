#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh

echo "ℹ️  Deploying the Azure Resource Groups using Bicep."
az deployment sub create \
    --name CycleCloudDeployment_RGs \
    --location "$location" \
    --template-file "./Bicep/resourceGroups.bicep" \
    --parameters \
        cycleCloudVMRGName="$cycleCloudVMRGName" \
        cycleCloudNetworkRGName="$cycleCloudNetworkRGName" \
        cycleCloudStorageRGName="$cycleCloudStorageRGName" \
        cycleCloudCostingRGName="$cycleCloudCostingRGName" \
        cycleCloudMonitoringRGName="$cycleCloudMonitoringRGName" \
        location="$location"