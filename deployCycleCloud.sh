#!/bin/bash
#loading vars and login to Azure
source loadvar.sh
source azCliAuthenticate.sh


# uncomment this to do the one time registration of the providers
# echo "Register the required providers, accept the terms and conditions for the Cyclecloud VM"
# az provider register --namespace Microsoft.Network
# az vm image terms accept --publisher azurecyclecloud --offer azure-cyclecloud --plan cyclecloud8-gen2

source ./deployCycleCloudRg.sh  #Required
source ./deployCycleCloudNetwork.sh #Required
source ./deployCycleCloudVm.sh #Required
source ./deployCycleCloudCostingDb.sh #Optional
source ./deployCycleCloudStorage.sh #Required
source ./deployCycleCloudSecurity.sh #Required
echo "🎉  Deployment completed."