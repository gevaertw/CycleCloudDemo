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
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: ['*']
            }
          ]
        }
      }
      {
        name: storageSubnetName
        properties: {
          addressPrefix: storageSubnetPrefix
/*           serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: ['*']
            }
          ] */
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
      {
        name: HPCCluster01SubnetName
        properties: {
          addressPrefix: HPCCluster01SubnetPrefix
        }
      }
      {
        name: HPCCluster02SubnetName
        properties: {
          addressPrefix: HPCCluster02SubnetPrefix
        }
      }
      {
        name: HPCCluster03SubnetName
        properties: {
          addressPrefix: HPCCluster03SubnetPrefix
        }
      }
      {
        name: HPCCluster04SubnetName
        properties: {
          addressPrefix: HPCCluster04SubnetPrefix
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
