param name string
param addressPrefixes array
param location string

module m_vnet 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: 'm_vnet'
  params: {
    name: name
    addressPrefixes: addressPrefixes
    location: location
  }
}

output vnetId string = m_vnet.outputs.resourceId
