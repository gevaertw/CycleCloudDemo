//param baseName string
param location string
param cycleCloudNetworkRGName string
param cycleCloudVnetName string
param cycleCloudSubnetName string
param storageSubnetName string
param HPCCluster01SubnetName string
param HPCCluster02SubnetName string
param HPCCluster03SubnetName string
param HPCCluster04SubnetName string
param StorageAccountExceptionIP string
param cycleCloudNFSStorageAccountName string

resource cycleCloudvNet_R 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: cycleCloudVnetName
  scope: resourceGroup(cycleCloudNetworkRGName)
}

resource cycleCloudSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: cycleCloudSubnetName
  parent: cycleCloudvNet_R
}

resource storageSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: storageSubnetName
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


resource storageAccountNFS_R 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: cycleCloudNFSStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    dnsEndpointType: 'Standard'
    publicNetworkAccess: 'Enabled'
    allowBlobPublicAccess: true
    isHnsEnabled: true //required for NFS
    isNfsV3Enabled: true
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'Logging, Metrics'
      virtualNetworkRules: [
        {
          id: cycleCloudSN_R.id
          action: 'Allow'
          state: 'Succeeded'
        }
        {
          id: HPCCluster01SN_R.id
          action: 'Allow'
          state: 'Succeeded'
        }
        {
          id: HPCCluster02SN_R.id
          action: 'Allow'
          state: 'Succeeded'
        }
        {
          id: HPCCluster03SN_R.id
          action: 'Allow'
          state: 'Succeeded'
        }
        {
          id: HPCCluster04SN_R.id
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      defaultAction: 'Deny'
      ipRules: [
        {
          // put public IPs of peoble that need access to the storage account here
          action: 'Allow'
          value: StorageAccountExceptionIP
        }
      ]
    }
  }
}


//Containers, not that clean to create them all individualu, but it works, schould be converted to parrent resource types etc.
resource storageContainerCycleNFS_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccountNFS_R.name}/default/cyclenfs'
  properties: {
    publicAccess: 'None'
  }
}
resource storageContainerSoftware_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccountNFS_R.name}/default/software'
  properties: {
    publicAccess: 'None'
  }
}
resource storageContainerproject1_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccountNFS_R.name}/default/project01'
  properties: {
    publicAccess: 'None'
  }
}
resource storageContainerproject2_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccountNFS_R.name}/default/project02'
  properties: {
    publicAccess: 'None'
  }
}
resource storageContainerproject3_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccountNFS_R.name}/default/project03'
  properties: {
    publicAccess: 'None'
  }
}
resource storageContainerproject4_R 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccountNFS_R.name}/default/project04'
  properties: {
    publicAccess: 'None'
  }
}
