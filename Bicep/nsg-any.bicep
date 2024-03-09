//Avoid the use of this NSG in production, it allows all traffic in and out

param location string = 'swedencentral'
param nsgName string = 'Any-nsg'

resource newNSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Inbound'
        properties: {
          description: 'Allows all traffic in.  Avoid the use of this NSG in production, it allows all traffic in and out'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      
      {
        name: 'Allow-Outbound'
        properties: {
          description: 'Allows all traffic out.  Avoid the use of this NSG in production, it allows all traffic in and out'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
    ]
  }

}
