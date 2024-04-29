param cycleCloudVMRGName string
param cycleCloudNetworkRGName string
param cycleCloudStorageRGName string
param location string

targetScope = 'subscription'

resource rg1 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudVMRGName
  location: location
}

resource rg2 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudNetworkRGName
  location: location
}

resource rg3 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: cycleCloudStorageRGName
  location: location
}
