# Create a custom role definition
az role definition create --role-definition CyclecloudCustomRBACRole.json
# Create user identity
az identity create --name $CyclecloudMi
# Get the identity id
$identityId=$(az identity show --name $CyclecloudMi --query id -o tsv)
# Assign the custom role to the identity with proper scope
az role assignment create --role CycleCloudRole --assignee-object-id $identityId --scope $managementSubscriptionName