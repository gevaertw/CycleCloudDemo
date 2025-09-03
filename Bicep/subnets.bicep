param name string
param vnetName string
param addressPrefixes array
param nsgId string = ''

module m_subnet 'br/public:avm/res/network/virtual-network/subnet:0.1.2' = {
  name: 'm_subnet'
  params: {
    virtualNetworkName: vnetName
    name: name
    addressPrefixes: addressPrefixes
    networkSecurityGroupResourceId: empty(nsgId) ? null : nsgId
  }
}
output subnetId string = m_subnet.outputs.resourceId
