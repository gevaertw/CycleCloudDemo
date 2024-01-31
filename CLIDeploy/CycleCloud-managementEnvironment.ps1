# call the powershell script setParameters.ps1 to set the parameters
. ./setParameters.ps1

# Log on to Azure
# az login

# Set the subscription
az account set --subscription $managementSubscriptionId

# create the RG for the management environment
az group create --name $managementRGName --location $managementRegion

# create the VNet for the management environment
az network vnet create `
  --resource-group $managementRGName `
  --name $managementVNetName `
  --address-prefixes $managementVNetAddressPrefix

# create the subnet for the management environment inside the management VNet
az network vnet subnet create `
  --resource-group $managementRGName `
  --vnet-name $managementVNetName `
  --name $managementSubnetName `
  --address-prefixes $managementSubnetAddressPrefix

# create a premium keyvault for the management environment
az keyvault create `
  --resource-group $managementRGName `
  --name $managementKeyvaultName `
  --location $managementRegion `
  --sku premium

# Install the bastion extension
az extension add --name bastion
az extension add --name ssh
  
#Bastion needs a public IP
az network public-ip create `
    --resource-group $managementRGName `
    --name $managementBastionPublicIPName `
    --sku Standard `
    --location $managementRegion
  
#create bastion subnet in vnet
az network vnet subnet create `
    --name AzureBastionSubnet `
    --resource-group $managementRGName `
    --vnet-name $managementVNetName `
    --address-prefixes $managementBastionAddressPrefix
  
#Create The bastion
az network bastion create `
    --name $managementBastionName `
    --public-ip-address $managementBastionPublicIPName `
    --resource-group $managementRGName `
    --vnet-name $managementVNetName `
    --location $managementRegion `
    --enable-tunneling true `
    --sku Standard

# create the public IP for the management VM
az network public-ip create `
  --resource-group $managementRGName `
  --name $managementPublicIPName `
  --sku Standard `
  --location $managementRegion

# Cretae a NIC for the management VM
az network nic create `
  --resource-group $managementRGName `
  --location $managementRegion `
  --name $managementVMNicName `
  --vnet-name $managementVNetName `
  --accelerated-networking false `
  --subnet $managementSubnetName `
  --public-ip-address $managementPublicIPName `

# Generate SSH key and store them in the keyvault for the management environment.  This part might be different for linux, this part is not secure for production!!
ssh-keygen -t rsa -b 2048 -f ./id_rsa_CycleCloud-management -q -N '""'
az keyvault secret set `
  --vault-name $managementKeyvaultName `
  --name "SSHPrivateKey" `
  --file "./id_rsa_CycleCloud-management"

az keyvault secret set `
  --vault-name $managementKeyvaultName `
  --name "SSHPublicKey" `
  --file "./id_rsa_CycleCloud-management.pub"

Remove-Item -Path "./id_rsa_CycleCloud-management.pub"
Remove-Item -Path "./id_rsa_CycleCloud-management"

$sshPublicKey = az keyvault secret show --name "SSHPublicKey" --vault-name $managementKeyvaultName --query value -o tsv

# create the RHEL VM with public IP
az vm create `
  --resource-group $managementRGName `
  --location $managementRegion `
  --size $managementVMSize `
  --name $managementVMName `
  --image $managementVMImage `
  --admin-username $managementVMAdminUserName `
  --nics $managementVMNicName `
  --os-disk-name $managementVMOSDiskName `
  --ssh-key-value "$sshPublicKey"

# create the NSG for the management environment 
az network nsg create `
  --resource-group $managementRGName `
  --name $managementNSGName

# associate the NSG with the subnet for the management environment
az network vnet subnet update `
  --resource-group $managementRGName `
  --vnet-name $managementVNetName `
  --name $managementSubnetName `
  --network-security-group $managementNSGName

# create the NSG rule to allow https traffic to the management VM
az network nsg rule create `
  --resource-group $managementRGName `
  --nsg-name $managementNSGName `
  --name AllowHTTPS `
  --protocol Tcp `
  --direction Inbound `
  --priority 1000 `
  --source-address-prefix Internet `
  --source-port-range "*" `
  --destination-address-prefix "*" `
  --destination-port-range 443 `
  --access Allow

# create the NSG rule to allow bastion traffic to the management vm
az network nsg rule create `
  --resource-group $managementRGName `
  --nsg-name $managementNSGName `
  --name AllowBastion `
  --protocol Tcp `
  --direction Inbound `
  --priority 1001 `
  --source-address-prefix $managementBastionAddressPrefix `
  --source-port-range "*" `
  --destination-address-prefix "*" `
  --destination-port-range 22 `
  --access Allow