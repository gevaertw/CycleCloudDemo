#!/bin/bash
#this script is used to simulate eviction of a spot instance

# Set the resource group name of the cluster
clusterRGName=002-GFQWIMDGGU2TQLLGGM3GCLJUGM

# Get the VMSS name and the number of instances
vmssName=$(az vmss list --resource-group $clusterRGName --query "[0].name" -o tsv)
echo $vmssName
instanceCount=$(az vmss list-instances --resource-group $clusterRGName --name $vmssName --query "length([])" -o tsv)
az vmss list-instances --resource-group $clusterRGName --name $vmssName --query "length([])"
echo $instanceCount

# evict a random instance
randomInstance=$((RANDOM % instanceCount))
echo $randomInstance
az vmss simulate-eviction --resource-group $clusterRGName --name hpc-24nn3gxe2beup --instance-id $randomInstance

