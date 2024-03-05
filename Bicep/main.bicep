//Basic stuff
param baseName string = 'CycleCloudPOC'
param location string = 'swedencentral'
param subscriptionID string

// Cyclecloud base Stuff
param cycleCloudVMRGName string = '${baseName}-vm-rg'
param cycleCloudVMName string = '${baseName}-Cycle-vm'
param cycleCloudVMSize string = 'Standard_D4s_v5'
param adminUsername string = 'cycleAdmin'
@secure()
param adminPassword string = 'Cycle_Cloud-1234'
param cycleCloudStorageAccountName string
param mgmtVMName string = '${baseName}-mgmt-vm'

// Network stuff
param cycleCloudNetworkRGName string = '${baseName}-net-rg'
param virtualNetworkName string = '${baseName}-vNet'
param addressPrefixes array = ['10.0.0.0/24','10.0.1.0/24']
param bastionHostName string = '${baseName}-bas'

param cycleCloudSubnetName string = '${virtualNetworkName}-CycleCloud-sn'
param cyclecloudSubnetPrefix string = ''
param storageSubnetName string = '${virtualNetworkName}-Storage-sn'
param storageSubnetPrefix string = ''
      //you cannot define the bastionsubnet name as it is a reserved name
param bastionSubnetPrefix string = ''
param HPCCluster01SubnetName string = '${virtualNetworkName}-HPCCluster01-sn'
param HPCCluster01SubnetPrefix string = ''
param HPCCluster02SubnetName string = '${virtualNetworkName}-HPCCluster02-sn'
param HPCCluster02SubnetPrefix string = ''
param HPCCluster03SubnetName string = '${virtualNetworkName}-HPCCluster03-sn'
param HPCCluster03SubnetPrefix string = ''
param HPCCluster04SubnetName string = '${virtualNetworkName}-HPCCluster04-sn'
param HPCCluster04SubnetPrefix string = ''


// vars
var cycleCloudSubnetID = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${cycleCloudNetworkRGName}/providers/Microsoft.Network/virtualNetworks/${virtualNetworkName}/subnets/${cycleCloudSubnetName}'
var storageSubnetID = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${cycleCloudNetworkRGName}/providers/Microsoft.Network/virtualNetworks/${virtualNetworkName}/subnets/${storageSubnetName}'

// Create the resource groups
targetScope = 'subscription'

resource cycleCloudVMRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: cycleCloudVMRGName
  location: location
}

resource cycleCloudNetworkRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: cycleCloudNetworkRGName
  location: location
}

// Deploy network stuff
module networkDeployment './network.bicep' = {
  name: 'networkDeployment'
  scope: resourceGroup(subscriptionID, cycleCloudNetworkRGName)
  dependsOn: [
    cycleCloudNetworkRG
  ]
  params: {
    baseName: baseName
    location: location
    bastionHostName: bastionHostName
    cycleCloudNetworkRGName: cycleCloudNetworkRGName
    virtualNetworkName: virtualNetworkName
    addressPrefixes: addressPrefixes
    cycleCloudSubnetName: cycleCloudSubnetName
    cyclecloudSubnetPrefix: cyclecloudSubnetPrefix
    storageSubnetName: storageSubnetName
    storageSubnetPrefix: storageSubnetPrefix
    bastionSubnetPrefix: bastionSubnetPrefix
    HPCCluster01SubnetName: HPCCluster01SubnetName
    HPCCluster01SubnetPrefix: HPCCluster01SubnetPrefix
    HPCCluster02SubnetName: HPCCluster02SubnetName
    HPCCluster02SubnetPrefix: HPCCluster02SubnetPrefix
    HPCCluster03SubnetName: HPCCluster03SubnetName
    HPCCluster03SubnetPrefix: HPCCluster03SubnetPrefix
    HPCCluster04SubnetName: HPCCluster04SubnetName
    HPCCluster04SubnetPrefix: HPCCluster04SubnetPrefix
  }
}

// Deploy CycleCloud
module cycleCloudDeployment './cyclecloud.bicep' = {
  name: 'cycleCloudDeployment'
  scope: resourceGroup(subscriptionID, cycleCloudVMRGName)
  dependsOn: [
    cycleCloudVMRG
  ]
  params: {
    baseName: baseName
    cycleCloudNetworkRGName: cycleCloudNetworkRGName
    virtualNetworkName: virtualNetworkName
    cycleCloudVMName: cycleCloudVMName
    cycleCloudSubnetID: cycleCloudSubnetID
    location: location
    virtualMachineSize: cycleCloudVMSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    cycleCloudStorageAccountName: cycleCloudStorageAccountName
    storageSubnetID: storageSubnetID
    mgmtVMName: mgmtVMName
  }
}
