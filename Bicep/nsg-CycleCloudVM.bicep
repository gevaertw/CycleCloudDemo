param location string = 'swedencentral'
param nsgName string = 'CycleCloudVM-nsg'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-amqp_5672'
        properties: {
          description: 'Allows AMQP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5672'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-https_9443'
        properties: {
          description: 'Allows HTTPS (special port) traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '9443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1101
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-AzureStorage'
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
        name: 'Allow-ActiveDirectory'
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
        name: 'Allow-AzureMonitor'
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
        name: 'Allow-AzureResourceManager'
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

    ]
  }

}
