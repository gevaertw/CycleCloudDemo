#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh

echo "Deploy Cyclecloud costing database using Bicep."
az deployment group create \
    --name CycleCloudDeployment_CycleCloud \
    --resource-group "$cycleCloudCostingRGName" \
    --template-file "./Bicep/cycleCloudCosting.bicep" \
    --parameters \
        location="$location" \
        cycleCloudNetworkRGName="$cycleCloudNetworkRGName" \
        cycleCloudVnetName="$cycleCloudVnetName" \
        cycleCloudSubnetName="$cycleCloudSubnetName" \
        costingDBSeverName="$costingDBSeverName" \
        costingDBName="$costingDBName" \
        adminPassword="$adminPassword" \
        costingDBskuName="$costingDBskuName" \
        costingDBskuTier="$costingDBskuTier"

