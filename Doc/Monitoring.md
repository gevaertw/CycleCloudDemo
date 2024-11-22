# Warning
Use at your own risk responsibility etc.  For POC purposes only, designed for functionality, not security.  Im not giving support, nor does my employer.  HPC can be expensive.  Watch your bill.
# What does this do? 
Adds a monitoring part to the Cyclecloud Demo.  

# Known issue's
- Not anymore :)

# Architecture overview
<img src="./monitoring.drawio.svg">


## install the az cli
- You need the az CLI installed on a linux host to install the Moneo infrastructure.
- To install az cli execute the script ```azCliInstallAlma.sh``` or the equivalent for your ubuntu version if required from this repo.

# Monitoring using Moneo

the installer can be found in ```/opt/azurehpc/tools/Moneo/deploy_managed_infra```

## Install Moneo infrastructure
Continue by installing the Moneo infrastructure in Azure, you need to execute this only once per CycleCloud instance. follow along with these steps: https://github.com/Azure/Moneo/blob/main/deploy_managed_infra/README.md

In short: 
- git clone the repo ```git clone https://github.com/Azure/Moneo```
- update the variables in the script ```deploy_managed_infra.sh``` to match your environment
- execute the script ```deploy_managed_infra.sh```

This should successfully deploy the Moneo infrastructure in your Azure subscription.

## Install a policy that adds a managed identity to every scale set deployed
execute ```moneoInstallPolicy.sh``` to install the policy that adds a managed identity to every scale set deployed.

## update the moneo config files to match your environment
- Edit the parameters in prom_config section in the file ```CycleCloudDemo/Installers/Moneo/moneo_config.json``` make sure the file is on the NFS server so that the central moneo script can access it.
    - IDENTITY_CLIENT_ID: the client id of the managed identity created by the moneo infrastructure
    - INGESTION_ENDPOIND: the ingestion endpoint of the Azure monitor workspace created by the moneo infrastructure, and linked to the Grafana.
- 
