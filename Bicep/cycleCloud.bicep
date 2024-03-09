//contains all stuff in the main resource group

param baseName string
param location string
param adminUsername string

param cycleCloudNetworkRGName string
param virtualNetworkName string
param cycleCloudLockerStorageAccountName string
param cycleCloudNFSStorageAccountName string

@secure()
param adminPassword string
param cycleCloudVMName string
param virtualMachineSize string

param cycleCloudSubnetID string
param storageSubnetID string
param cluster01SubnetID string

param mgmtVMName string

resource cycleCloudSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: cycleCloudSubnetID
}

resource storageSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: storageSubnetID
}

resource cluster01Subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: cluster01SubnetID
}


var mgmtVMNicName = '${mgmtVMName}-nic'
var CycleCloudVMNicName = '${cycleCloudVMName}-nic'
var CyclecloudVMKeyName = '${cycleCloudVMName}-sshKey'

var cycleCloudStorageAccountCycleCloudSubnetPrivateEndpointName = '${cycleCloudLockerStorageAccountName}-cycleCloudSubnet-pe'
var cycleCloudStorageAccountStorageSubnetPrivateEndpointName = '${cycleCloudLockerStorageAccountName}-storageSubnet-pe'
var cycleCloudStorageAccountCluster01SubnetPrivateEndpointName = '${cycleCloudLockerStorageAccountName}-cluster01Subnet-pe'


resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: CyclecloudVMKeyName
  location: location
  properties: {}  
}



// VM networking
resource CycleCloudVMNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: CycleCloudVMNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: cycleCloudSubnetID
          }
          privateIPAllocationMethod: 'Dynamic'

        }
      }
    ]
  }
}


resource mgmtVMnic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: mgmtVMNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: cycleCloudSubnetID
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource cycleCloudVirtualMachine 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: cycleCloudVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: CycleCloudVMNic.id
        }
      ]
    }
    storageProfile: {
      osDisk: {
        name: '${cycleCloudVMName}-osdisk'
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'azurecyclecloud'
        offer: 'azure-cyclecloud'
        sku: 'cyclecloud8-gen2'
        version: 'latest'
      }
    }

    additionalCapabilities: {
      hibernationEnabled: false
    }
    osProfile: {
      computerName: cycleCloudVMName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: 'ImageDefault'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  plan: {
    name: 'cyclecloud8-gen2'
    publisher: 'azurecyclecloud'
    product: 'azure-cyclecloud'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource mgmtVM 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: mgmtVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'windows-11'
        sku: 'win11-22h2-entn'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    osProfile: {
      computerName: mgmtVMName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: mgmtVMnic.id
        }
      ]
    }
  }
}

resource storageAccountLocker 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: cycleCloudLockerStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    isHnsEnabled: false //not allowed for cyclecloud
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'Logging, Metrics'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: cycleCloudSubnetID
        }
        {
          action: 'Allow'
          id: cluster01SubnetID
        }
      ]
      ipRules: [
        {
          // put public IPs of peoble that need access to the storage account here
          action: 'Allow'
          value: '109.134.193.156'
        }
      ]
    }
  }
}

resource storageAccountNFS 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: cycleCloudNFSStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    isHnsEnabled: true //required for NFS
    isNfsV3Enabled: true
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'Logging, Metrics'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: cycleCloudSubnetID
        }
        {
          action: 'Allow'
          id: cluster01SubnetID
        }
      ]
      ipRules: [
        {
          // put public IPs of peoble that need access to the storage account here
          action: 'Allow'
          value: '109.134.193.156'
        }
      ]
    }
  }
}

resource privateEndpointStorageSubnet 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: cycleCloudStorageAccountCycleCloudSubnetPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: storageSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'myPrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: storageAccountLocker.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateEndpointCycleCloudSubnet 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: cycleCloudStorageAccountStorageSubnetPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: cycleCloudSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'myPrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: storageAccountLocker.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateEndpointCluster01SubnetSubnet 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: cycleCloudStorageAccountCluster01SubnetPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: cluster01SubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'myPrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: storageAccountLocker.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

//not that clean to create them all individualu, but it works
resource storageContainerCycleNFS 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccountNFS.name}/default/cyclenfs'
  properties: {
    publicAccess: 'None'
  }
}



resource storageContainerproject1 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccountNFS.name}/default/project1'
  properties: {
    publicAccess: 'None'
  }
}

resource storageContainerproject2 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccountNFS.name}/default/project2'
  properties: {
    publicAccess: 'None'
  }
}
