// contains the networking part of the code for the CycleCloud deployment

param baseName string
param location string

// Network stuff
//param cycleCloudNetworkRGName string
param cycleCloudVnetName string
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

var bastionHostName = '${baseName}-bas'
var bastionPublicIpName = '${bastionHostName}-pip'
var bastionNSGName = '${baseName}-bastion-nsg'
var cycleCloudNSGName = '${baseName}-cycleCloud-nsg'
var cycleCloudClusterNSGName = '${baseName}-cycleCloudCluster-nsg'
var cycleCloudStorageNSGName = '${baseName}-cycleCloudStorage-nsg'
var cycleCloudAnyNSGName = '${baseName}-AllowAny-nsg'

//Create NSGs
module nsgBastion_m './nsg-Bastion.bicep' = {
  name: bastionNSGName
  params: {
    nsgName: bastionNSGName
    location: location
  }
}

module nsgCycleCloud_m './nsg-CycleCloudVM.bicep' = {
  name: cycleCloudNSGName
  params: {
    nsgName: cycleCloudNSGName
    location: location
  }
}

module nsgCycleCloudCluster_m './nsg-CycleCloudCluster.bicep' = {
  name: cycleCloudClusterNSGName
  params: {
    nsgName: cycleCloudClusterNSGName
    location: location
  }
}

module nsgCycleCloudStorage_m './nsg-CycleCloudStorage.bicep' = {
  name: cycleCloudStorageNSGName
  params: {
    nsgName: cycleCloudStorageNSGName
    location: location
  }
}

module nsgAny_m './nsg-any.bicep' = {
  name: cycleCloudAnyNSGName
  params: {
    nsgName: cycleCloudAnyNSGName
    location: location
  }
}

// create the vnet
resource cycleCloudvNet_R 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: cycleCloudVnetName
  location: location
  dependsOn: [nsgBastion_m, nsgCycleCloud_m, nsgCycleCloudCluster_m, nsgCycleCloudStorage_m, nsgAny_m]
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: cycleCloudSubnetName
        properties: {
          addressPrefix: cyclecloudSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudNSG_R.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: storageSubnetName
        properties: {
          addressPrefix: storageSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudStorageNSG_R.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
          networkSecurityGroup: {
            id: bastionNSG_R.id
          }
        }
        
      }
      {
        name: HPCCluster01SubnetName
        properties: {
          addressPrefix: HPCCluster01SubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_R.id
          }
        }
      }
      {
        name: HPCCluster02SubnetName
        properties: {
          addressPrefix: HPCCluster02SubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_R.id
          }
        }
      }
      {
        name: HPCCluster03SubnetName
        properties: {
          addressPrefix: HPCCluster03SubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_R.id
          }
        }
      }
      {
        name: HPCCluster04SubnetName
        properties: {
          addressPrefix: HPCCluster04SubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
          networkSecurityGroup: {
            id: cycleCloudClusterNSG_R.id
          }
        }
      }
    ]
  }
}

// not all is used, but it is a good way to get the id of the existing resources
resource cycleCloudNSG_R 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: cycleCloudNSGName
}
resource cycleCloudClusterNSG_R 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: cycleCloudClusterNSGName
}
resource bastionNSG_R 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: bastionNSGName
}
resource cycleCloudStorageNSG_R 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: cycleCloudStorageNSGName
}
resource cycleCloudSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: cycleCloudSubnetName
  parent: cycleCloudvNet_R
}
resource storageSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: storageSubnetName
  parent: cycleCloudvNet_R
}
resource BastionSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: 'AzureBastionSubnet'
  parent: cycleCloudvNet_R
}
resource HPCCluster01SN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: HPCCluster01SubnetName
  parent: cycleCloudvNet_R
}
resource HPCCluster02SN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: HPCCluster02SubnetName
  parent: cycleCloudvNet_R
}
resource HPCCluster03SN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: HPCCluster03SubnetName
  parent: cycleCloudvNet_R
}
resource HPCCluster04SN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: HPCCluster04SubnetName
  parent: cycleCloudvNet_R
}

// Bastion stuff
resource bastionPublicIP_R 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
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

resource bastionHost_R 'Microsoft.Network/bastionHosts@2023-04-01' = {
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
            id: bastionPublicIP_R.id
          }
          subnet: {
            id: BastionSN_R.id
          }
        }
      }
    ]
  }
}
