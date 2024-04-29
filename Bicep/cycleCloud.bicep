//contains all stuff in the main resource group

//param baseName string
param location string
param cycleCloudNetworkRGName string
param cycleCloudVnetName string
param cycleCloudSubnetName string
param HPCCluster01SubnetName string
param HPCCluster02SubnetName string
param HPCCluster03SubnetName string
param HPCCluster04SubnetName string
param StorageAccountExceptionIP string
param cycleCloudLockerStorageAccountName string
param adminUsername string
@secure()
param adminPassword string
param cycleCloudVMName string
param virtualMachineSize string
param mgmtVMName string

resource cycleCloudvNet_R 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: cycleCloudVnetName
  scope: resourceGroup(cycleCloudNetworkRGName)
}

resource cycleCloudSN_R 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: cycleCloudSubnetName
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

/* resource virtualNetworkNameResource_R 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: cycleCloudVnetName
} */

var mgmtVMNicName = '${mgmtVMName}-nic'
var CycleCloudVMNicName = '${cycleCloudVMName}-nic'

// VM networking
resource CycleCloudVMNic_R 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: CycleCloudVMNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: cycleCloudSN_R.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource mgmtVMnic_R 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: mgmtVMNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: cycleCloudSN_R.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Cyclecloud Server
resource cycleCloudVirtualMachine_R 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: cycleCloudVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: CycleCloudVMNic_R.id
        }
      ]
    }
    storageProfile: {
      osDisk: {
        name: '${cycleCloudVMName}-osdisk'
        createOption: 'fromImage'
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

// Management VM
resource mgmtVM_R 'Microsoft.Compute/virtualMachines@2021-07-01' = {
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
          id: mgmtVMnic_R.id
        }
      ]
    }
  }
}

// Storage accounts
resource storageAccountLocker_R 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: cycleCloudLockerStorageAccountName
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
    isHnsEnabled: false //not allowed for cyclecloud
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'Logging, Metrics, AzureServices'
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
          // put public IPs that data need access to the storage account here
          action: 'Allow'
          value: StorageAccountExceptionIP
        }
      ]
    }
  }
}
