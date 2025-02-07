param cycleCloudVMRGName string
param cycleCloudNetworkRGName string
param cycleCloudStorageRGName string
param cycleCloudCostingRGName string
param cycleCloudMonitoringRGName string
param location string

targetScope = 'subscription'

resource cycleCloudRG_R 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudVMRGName
  location: location
}

resource cycleCloudNetworkRG_R 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudNetworkRGName
  location: location
}

resource cycleCloudStorageRG_R 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudStorageRGName
  location: location
}

resource cycleCloudCostingRG_R 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudCostingRGName
  location: location
}

resource cycleCloudMonitoringRGName_R 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudMonitoringRGName
  location: location
}
