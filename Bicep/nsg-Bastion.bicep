param location string = 'swedencentral'
param nsgName string = 'Bastion-nsg'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Bastion-CorpNetPublic-Allow'
        properties: {
          description: 'Allow CorpNetPublic traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'Bastion-CorpNetSaw-Allow'
        properties: {
          description: 'Allow CorpNetSaw traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1102
          direction: 'Inbound'
        }
      }

      {
        name: 'Bastion-Internet-Allow'
        properties: {
          description: 'Allow Internet traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1103
          direction: 'Inbound'
        }
      }
      {
        name: 'Bastion-GatewayManager-Allow'
        properties: {
          description: 'Allow GatewayManager traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1104
          direction: 'Inbound'
        }
      }
      
      {
        name: 'Bastion-RDP-Allow'
        properties: {
          description: 'Allow RDP traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1101
          direction: 'Outbound'
        }
      }
      {
        name: 'Bastion-ssh-Allow'
        properties: {
          description: 'Allow SSH traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1102
          direction: 'Outbound'
        }
      }
      {
        name: 'Bastion-Cloud-Allow'
        properties: {
          description: 'Allow SSH traffic for Azure Bastion'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 1103
          direction: 'Outbound'
        }
      }
    ]
  }
}
