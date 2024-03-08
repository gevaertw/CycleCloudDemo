targetScope = 'subscription'

@description('Array of actions for the roleDefinition')
param actions array = [
  'Microsoft.Commerce/RateCard/read'
  'Microsoft.Compute/*/read'
  'Microsoft.Compute/availabilitySets/*'
  'Microsoft.Compute/disks/*'
  'Microsoft.Compute/images/read'
  'Microsoft.Compute/locations/usages/read'
  'Microsoft.Compute/register/action'
  'Microsoft.Compute/skus/read'
  'Microsoft.Compute/virtualMachines/*'
  'Microsoft.Compute/virtualMachineScaleSets/*'
  'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/*'
  'Microsoft.ManagedIdentity/userAssignedIdentities/*/assign/action'
  'Microsoft.Network/*/read'
  'Microsoft.Network/locations/*/read'
  'Microsoft.Network/networkInterfaces/read'
  'Microsoft.Network/networkInterfaces/write'
  'Microsoft.Network/networkInterfaces/delete'
  'Microsoft.Network/networkInterfaces/join/action'
  'Microsoft.Network/networkSecurityGroups/read'
  'Microsoft.Network/networkSecurityGroups/write'
  'Microsoft.Network/networkSecurityGroups/delete'
  'Microsoft.Network/networkSecurityGroups/join/action'
  'Microsoft.Network/publicIPAddresses/read'
  'Microsoft.Network/publicIPAddresses/write'
  'Microsoft.Network/publicIPAddresses/delete'
  'Microsoft.Network/publicIPAddresses/join/action'
  'Microsoft.Network/register/action'
  'Microsoft.Network/virtualNetworks/read'
  'Microsoft.Network/virtualNetworks/subnets/read'
  'Microsoft.Network/virtualNetworks/subnets/join/action'
  'Microsoft.Resources/deployments/read'
  'Microsoft.Resources/subscriptions/resourceGroups/read'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/read'
  'Microsoft.Resources/subscriptions/operationresults/read'
  'Microsoft.Storage/*/read'
  'Microsoft.Storage/checknameavailability/read'
  'Microsoft.Storage/register/action'
  'Microsoft.Storage/storageAccounts/read'
  'Microsoft.Storage/storageAccounts/listKeys/action'
  'Microsoft.Storage/storageAccounts/write'
  'Microsoft.Authorization/*/read'
  'Microsoft.Authorization/roleAssignments/*'
  'Microsoft.Authorization/roleDefinitions/*'
  'Microsoft.Resources/subscriptions/resourceGroups/read'
  'Microsoft.Resources/subscriptions/resourceGroups/write'
  'Microsoft.Resources/subscriptions/resourceGroups/delete'
  'Microsoft.MarketplaceOrdering/offerTypes/publishers/offers/plans/agreements/read'
  
]

@description('Array of notActions for the roleDefinition')
param notActions array = []

@description('Friendly name of the role definition')
param roleName string = 'Custom Role - CycleCloud system assigned identity'

@description('Detailed description of the role definition')
param roleDescription string = 'This custom role contains the minimum permissions required for CycleCloud to manage resources in the subscription. It is intended to be assigned to the system assigned identity of the CycleCloud application.'

var roleDefName = guid(roleName)

resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: roleDefName
  properties: {
    roleName: roleName
    description: roleDescription
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}
