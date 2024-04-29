param location string = 'swedencentral'
param privateEndpointName string = 'name-pe'
param privateEndpointSubnetID string
param groupIds string 
param privateLinkServiceId string // something l/subscriptions/c6900d9a-d481-4659-b69e-5bbe9bfd27f8/resourceGroups/CycleCloudPOC-vm-rg/providers/Microsoft.Storage/storageAccounts/nfscyclesa8168kt436864'
param privateDnsZoneId string // /subscriptions/c6900d9a-d481-4659-b69e-5bbe9bfd27f8/resourceGroups/CycleCloudPOC-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'


resource privateEndpoint_R 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [
            groupIds
          ]
        }
      }
    ]
    //manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpointName}-nic'
    subnet: {
      id: privateEndpointSubnetID
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}


resource privateEndpoints_manual_File_pe_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
  name: '${privateEndpointName}/default'
  dependsOn: [privateEndpoint_R]
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}
 
 output privateEndpointID string = privateEndpoint_R.id
 output privateEndpointNivID string = privateEndpoint_R.properties.networkInterfaces[0].id
