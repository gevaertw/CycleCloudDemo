param location string = 'swedencentral'
param nsgName string = 'CycleCloudCluster-nsg'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      //INBOUND RULES -------------------------------------------------------------------------------------------------------
      {
        name: 'Allow-Ganglia_8649_inbound'
        properties: {
          description: 'Allows Ganglia '
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8652'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1105
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-SSH_22_inbound'
        properties: {
          description: 'Allows SSH from Cyclecloud'
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

      //OUTBOUND RULES -------------------------------------------------------------------------------------------------------

      {
        name: 'Allow-amqp_5672_outbound'
        properties: {
          description: 'Allows AMQP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5672'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1100
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-https_9443_outbound'
        properties: {
          description: 'Allows HTTPS (special port) traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '9443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 1101
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-internet_outbound'
        properties: {
          description: 'Allows internet access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: ['80', '443']
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
