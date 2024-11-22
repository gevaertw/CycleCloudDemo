param location string
param cycleCloudNetworkRGName string
param cycleCloudVnetName string
param cycleCloudSubnetName string
param costingDBSeverName string
param costingDBName string

@secure()
param adminPassword string

param costingDBskuName string = 'Standard_B1ms'
param costingDBskuTier string = 'Burstable'

var costingDBPEName = '${costingDBSeverName}-pe'
var costingDBPLName = '${costingDBSeverName}-pl'

resource cycleCloudvNet_R 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: cycleCloudVnetName
  scope: resourceGroup(cycleCloudNetworkRGName)
}

resource cycleCloudSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: cycleCloudSubnetName
  parent: cycleCloudvNet_R
}

// CostingDB

// Create MySQL Server
resource MySQLServer_R 'Microsoft.DBforMySQL/flexibleServers@2023-10-01-preview' = {
  name: costingDBSeverName
  location: location
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: adminPassword
    version: '5.7'
    network: {
      publicNetworkAccess: 'Disabled'
    }

    storage: {
      storageSizeGB: 512
    }
    createMode: 'Default'
    
  }
  sku: {
    name: costingDBskuName
    tier: costingDBskuTier
  }
}

// Create MySQL Database
resource costingDBName_R 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-30' = {
  name: '${costingDBSeverName}/${costingDBName}'
  dependsOn: [MySQLServer_R]
  properties: {}
}

// Create Private Endpoint for database
resource costingDBPEName_R 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: costingDBPEName
  location: location
  properties: {
    subnet: {
      id: cycleCloudSN_R.id
    }
    privateLinkServiceConnections: [
      {
        name: costingDBPLName
        properties: {
          privateLinkServiceId: MySQLServer_R.id
          groupIds: [
            'mysqlServer'
          ]
        }
      }
    ]
  }
}
