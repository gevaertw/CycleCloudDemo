// contains the networking part of the code for the CycleCloud deployment

param baseName string
param location string

// Network stuff
param cycleCloudNetworkRGName string
param virtualNetworkName string
param addressPrefixes array

param cycleCloudSubnetName string
param cyclecloudSubnetPrefix string
param storageSubnetName string
param storageSubnetPrefix string
//you cannot define the bastionsubnet name as it is a reserved name
param bastionSubnetPrefix string
param HPCCluster01SubnetName string
param HPCCluster01SubnetPrefix string
param HPCCluster02SubnetName string
param HPCCluster02SubnetPrefix string
param HPCCluster03SubnetName string
param HPCCluster03SubnetPrefix string
param HPCCluster04SubnetName string
param HPCCluster04SubnetPrefix string

param bastionHostName string
var bastionPublicIpName = '${bastionHostName}-pip'

var bastionNSGName = '${baseName}-bastion-nsg'
var cycleCloudVMNSGName = '${baseName}-cycleCloudVM-nsg'
var cycleCloudClusterNSGName = '${baseName}-cycleCloudCluster-nsg'
var cycleCloudStorageSGName = '${baseName}-cycleCloudStorageSG-nsg'

resource cycleCloudNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: cycleCloudSubnetName
        properties: {
          addressPrefix: cyclecloudSubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudVMNSG_Resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [ '*' ]
            }
            {
              service: 'Microsoft.keyvault'
              locations: [ '*' ]
            }
          ]
        }
      }
      {
        name: storageSubnetName
        properties: {
          addressPrefix: storageSubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudStorageNSG_Resource.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
          networkSecurityGroup: {
            id: bastionNSG_Resource.id
          }
        }
      }
      {
        name: HPCCluster01SubnetName
        properties: {
          addressPrefix: HPCCluster01SubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_Resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [ '*' ]
            }
            {
              service: 'Microsoft.keyvault'
              locations: [ '*' ]
            }
          ]

        }
      }
      {
        name: HPCCluster02SubnetName
        properties: {
          addressPrefix: HPCCluster02SubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_Resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [ '*' ]
            }
            {
              service: 'Microsoft.keyvault'
              locations: [ '*' ]
            }
          ]
        }
      }
      {
        name: HPCCluster03SubnetName
        properties: {
          addressPrefix: HPCCluster03SubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_Resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [ '*' ]
            }
            {
              service: 'Microsoft.keyvault'
              locations: [ '*' ]
            }
          ]
        }
      }
      {
        name: HPCCluster04SubnetName
        properties: {
          addressPrefix: HPCCluster04SubnetPrefix
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_Resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [ '*' ]
            }
            {
              service: 'Microsoft.keyvault'
              locations: [ '*' ]
            }
          ]
        }
      }
    ]
  }
}

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: bastionPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: bastionHostName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    scaleUnits: 2
    dnsName: bastionHostName
    disableCopyPaste: false
    enableFileCopy: true
    enableShareableLink: false
    enableTunneling: true
    ipConfigurations: [
      {
        name: '${bastionHostName}-ipConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: bastionPublicIP.id
          }
          subnet: {
            id: cycleCloudNetwork.properties.subnets[2].id
          }
        }
      }
    ]

  }
}

//nsg stuff
module nsgBastion './nsg-Bastion.bicep' = {
  name: '${baseName}-Bastion-nsg'
  params: {
    nsgName: bastionNSGName
    location: location
  }
}

resource bastionNSG_Resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' existing= {
  name: bastionNSGName
}

module nsgCycleCloudCluster './nsg-CycleCloudCluster.bicep' = {
  name: '${baseName}-CycleCloudCluster-nsg'
  params: {
    nsgName: cycleCloudClusterNSGName
    location: location
  }
}

resource cycleCloudClusterNSG_Resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' existing= {
  name: cycleCloudClusterNSGName
}

module nsgCycleCloudVM './nsg-CycleCloudVM.bicep' = {
  name: '${baseName}-CycleCloudVM-nsg'
  params: {
    nsgName: cycleCloudVMNSGName
    location: location
  }
}
resource cycleCloudVMNSG_Resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' existing= {
  name: cycleCloudVMNSGName
}

module nsgCycleCloudStorage './nsg-CycleCloudStorage.bicep' = {
  name: '${baseName}-CycleCloudStorage-nsg'
  params: {
    nsgName: cycleCloudStorageSGName
    location: location
  }
}

resource cycleCloudStorageNSG_Resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' existing= {
  name: cycleCloudStorageSGName
}
