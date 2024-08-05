#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)
# based on https://github.com/Azure/Moneo/blob/main/docs/HeadlessDeployment.md

# Run this script on all nodes in the scale set, by starting it from the cyclecloud cloud init script.  It assumes that the azure install part, where you add the user assigned identity to the VMSS has already been done.

# Copy the config files from the NFS share and start the service.  If you have named the NFS share differently or you gip cloned in another directory, you will need to adjust the paths. 
yes | \cp /cyclenfs/CycleCloudDemo/Installers/Moneo/moneo_config.json /opt/azurehpc/tools/Moneo/moneo_config.json

# Start the service
/opt/azurehpc/tools/Moneo/linux_service/start_moneo_services.sh

