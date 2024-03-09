param location string = 'swedencentral'
param nsgName string = 'CycleCloudCluster-nsg'

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
          direction: 'Outbound'
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
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-internet'
        properties: {
          description: 'Allows internet access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [ '80', '443' ]
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 1102
          direction: 'Outbound'
        }
      }
    ]
  }

}
