#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh


bastionHostName="${baseName}-bas"
bastionPublicIpName="${bastionHostName}-pip"
bastionNSGName="${baseName}-bastion-nsg"
cycleCloudNSGName="${baseName}-cycleCloud-nsg"
cycleCloudClusterNSGName="${baseName}-cycleCloudCluster-nsg"
cycleCloudStorageNSGName="${baseName}-cycleCloudStorage-nsg"
cycleCloudAnyNSGName="${baseName}-AllowAny-nsg"


#------------------------------------------------------------------------------NSG-----------------------------------------------
echo "ℹ️  Deploying NSG ${bastionNSGName} using verified module..."
bastionNSGId=$(az deployment group create \
  --name "deployment-${location}-bastionNsg-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/nsg-Bastion.bicep" \
  --query "properties.outputs.nsgId.value" --output tsv \
  --parameters nsgName="${bastionNSGName}" location="${location}")
echo "ℹ️  NSG ${bastionNSGName} deployed with ID: ${bastionNSGId}"

echo "ℹ️  Deploying NSG ${cycleCloudNSGName} using verified module..."
cycleCloudNSGId=$(az deployment group create \
  --name "deployment-${location}-cycleCloudNsg-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/nsg-CycleCloudVM.bicep" \
  --query "properties.outputs.nsgId.value" --output tsv \
  --parameters nsgName="${cycleCloudNSGName}" location="${location}")
echo "ℹ️  NSG ${cycleCloudNSGName} deployed with ID: ${cycleCloudNSGId}"

echo "ℹ️  Deploying NSG ${cycleCloudClusterNSGName} using verified module..."
cycleCloudClusterNSGId=$(az deployment group create \
  --name "deployment-${location}-cycleCloudClusterNsg-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/nsg-CycleCloudCluster.bicep" \
  --query "properties.outputs.nsgId.value" --output tsv \
  --parameters nsgName="${cycleCloudClusterNSGName}" location="${location}")
echo "ℹ️  NSG ${cycleCloudClusterNSGName} deployed with ID: ${cycleCloudClusterNSGId}"

echo "ℹ️  Deploying NSG ${cycleCloudStorageNSGName} using verified module..."
cycleCloudStorageNSGId=$(az deployment group create \
  --name "deployment-${location}-cycleCloudStorageNsg-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/nsg-CycleCloudStorage.bicep" \
  --query "properties.outputs.nsgId.value" --output tsv \
  --parameters nsgName="${cycleCloudStorageNSGName}" location="${location}")
echo "ℹ️  NSG ${cycleCloudStorageNSGName} deployed with ID: ${cycleCloudStorageNSGId}"

echo "ℹ️  Deploying NSG ${cycleCloudAnyNSGName} using verified module..."
cycleCloudAnyNSGId=$(az deployment group create \
  --name "deployment-${location}-cycleCloudAnyNsg-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/nsg-any.bicep" \
  --query "properties.outputs.nsgId.value" --output tsv \
  --parameters nsgName="${cycleCloudAnyNSGName}" location="${location}")
echo "ℹ️  NSG ${cycleCloudAnyNSGName} deployed with ID: ${cycleCloudAnyNSGId}"


#------------------------------------------------------------------------------vNet-----------------------------------------------
echo "ℹ️  Deploying vnet using verified module..."
cycleCloudVnetId=$(az deployment group create \
  --name "deployment-${location}-${vnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/vnet.bicep" \
  --query "properties.outputs.vnetId.value" --output tsv \
  --parameters name=${cycleCloudVnetName} addressPrefixes="['${addressPrefixes}']" location=${location})
echo "ℹ️  VNet ${cycleCloudVnetName} deployed with ID: ${cycleCloudVnetId}"

echo "ℹ️  Deploying subnet ${cycleCloudSubnetName} using verified module..."
cycleCloudSubnetId=$(az deployment group create \
  --name "deployment-${location}-${cycleCloudSubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${cycleCloudSubnetName}" addressPrefixes="['${cyclecloudSubnetPrefix}']" nsgId=${cycleCloudNSGId})
echo "ℹ️  Subnet ${cycleCloudSubnetName} deployed with ID: ${cycleCloudSubnetId}"

echo "ℹ️  Deploying subnet ${storageSubnetName} using verified module..."
storageSubnetId=$(az deployment group create \
  --name "deployment-${location}-${storageSubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${storageSubnetName}" addressPrefixes="['${storageSubnetPrefix}']" nsgId=${cycleCloudStorageNSGId})
echo "ℹ️  Subnet ${storageSubnetName} deployed with ID: ${storageSubnetId}"

echo "ℹ️  Deploying subnet ${bastionSubnetName} using verified module..."
bastionSubnetId=$(az deployment group create \
  --name "deployment-${location}-${bastionSubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${bastionSubnetName}" addressPrefixes="['${bastionSubnetPrefix}']" nsgId=${cycleCloudBastionNSGId})
echo "ℹ️  Subnet ${bastionSubnetName} deployed with ID: ${bastionSubnetId}"

echo "ℹ️  Deploying subnet ${HPCCluster01SubnetName} using verified module..."
HPCCluster01SubnetId=$(az deployment group create \
  --name "deployment-${location}-${HPCCluster01SubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${HPCCluster01SubnetName}" addressPrefixes="['${HPCCluster01SubnetPrefix}']" nsgId=${cycleCloudClusterNSGId})
echo "ℹ️  Subnet ${HPCCluster01SubnetName} deployed with ID: ${HPCCluster01SubnetId}"

echo "ℹ️  Deploying subnet ${HPCCluster02SubnetName} using verified module..."
HPCCluster02SubnetId=$(az deployment group create \
  --name "deployment-${location}-${HPCCluster02SubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${HPCCluster02SubnetName}" addressPrefixes="['${HPCCluster02SubnetPrefix}']" nsgId=${cycleCloudClusterNSGId})
echo "ℹ️  Subnet ${HPCCluster02SubnetName} deployed with ID: ${HPCCluster02SubnetId}"

echo "ℹ️  Deploying subnet ${HPCCluster03SubnetName} using verified module..."
HPCCluster03SubnetId=$(az deployment group create \
  --name "deployment-${location}-${HPCCluster03SubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${HPCCluster03SubnetName}" addressPrefixes="['${HPCCluster03SubnetPrefix}']" nsgId=${cycleCloudClusterNSGId})
echo "ℹ️  Subnet ${HPCCluster03SubnetName} deployed with ID: ${HPCCluster03SubnetId}"

echo "ℹ️  Deploying subnet ${HPCCluster04SubnetName} using verified module..."
HPCCluster04SubnetId=$(az deployment group create \
  --name "deployment-${location}-${HPCCluster04SubnetName}-$(date +%Y%m%d%H%M%S)" \
  --resource-group "${cycleCloudNetworkRGName}" \
  --template-file "./Bicep/subnets.bicep" \
  --query "properties.outputs.subnetId.value" --output tsv \
  --parameters vnetName="${cycleCloudVnetName}" name="${HPCCluster04SubnetName}" addressPrefixes="['${HPCCluster04SubnetPrefix}']" nsgId=${cycleCloudClusterNSGId})
echo "ℹ️  Subnet ${HPCCluster04SubnetName} deployed with ID: ${HPCCluster04SubnetId}"



