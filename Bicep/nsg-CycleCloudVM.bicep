param location string = 'swedencentral'
param nsgName string = 'CycleCloudVM-nsg'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [

//INBOUND RULES -------------------------------------------------------------------------------------------------------
      {
        name: 'Allow-amqp_5672_inbound'
        properties: {
          description: 'Allows AMQP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5672'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-https_9443_inbound'
        properties: {
          description: 'Allows HTTPS (special port) traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '9443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1101
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-SSH_22_inbound'
        properties: {
          description: 'Allows SSH to cluster nodes'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1106
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-MySQL_3306_inbound'
        properties: {
          description: 'Allows SSH to costing database'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3306'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1107
          direction: 'Inbound'
        }
      }
//OUTBOUND RULES -------------------------------------------------------------------------------------------------------
      {
        name: 'Allow-AzureStorage_443_outbound'
        properties: {
          description: 'Allows Azure Storage access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 1100
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-ActiveDirectory_443_outbound'
        properties: {
          description: 'Allows Azure AD access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 1101
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-AzureMonitor_443_outbound'
        properties: {
          description: 'Allows Azure Monitor access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
          priority: 1102
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-AzureResourceManager_443_outbound'
        properties: {
          description: 'Allows Azure ResourceManager access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureResourceManager'
          access: 'Allow'
          priority: 1103
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-Internet_443_outbound'
        properties: {
          description: 'Allows Azure Storage access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 1104
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-Ganglia_8652_outbound'
        properties: {
          description: 'Allows Ganglia '
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8652'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1105
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-SSH_22_outbound'
        properties: {
          description: 'Allows SSH to cluster nodes'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1106
          direction: 'Outbound'
        }
      }
    ]
  }

}
