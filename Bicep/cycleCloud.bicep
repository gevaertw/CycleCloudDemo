//contains all stuff in the main resource group

param baseName string
param location string
param adminUsername string

param cycleCloudNetworkRGName string
param virtualNetworkName string
param cycleCloudStorageAccountName string

@secure()
param adminPassword string
param cycleCloudVMName string
param virtualMachineSize string

param cycleCloudSubnetID string
param storageSubnetID string

param mgmtVMName string

var mgmtVMNicName = '${mgmtVMName}-nic'
var CycleCloudVMNicName = '${cycleCloudVMName}-nic'

var cycleCloudStorageAccountPrivateEndpointName = '${cycleCloudStorageAccountName}-pe'

resource cycleCloudSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: cycleCloudSubnetID
}

resource storageSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: storageSubnetID
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: cycleCloudStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    isHnsEnabled: true
    isNfsV3Enabled: true
    networkAcls: {
      bypass: 'Logging, Metrics'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: cycleCloudSubnetID
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

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: cycleCloudStorageAccountPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: storageSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'myPrivateLinkServiceConnection'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource storageContainerCycleshared 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/cycleshared'
  properties: {
    publicAccess: 'None'
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/project1'
  properties: {
    publicAccess: 'None'
  }
}
