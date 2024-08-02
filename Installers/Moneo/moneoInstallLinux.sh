#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

# based on https://github.com/Azure/Moneo/blob/main/docs/HeadlessDeployment.md

# Run this script on all nodes in the scale set, by starting it from the cyclecloud cloud init script

# Copy the config files from the NFS share and start the service
yes | \cp /cyclenfs/software/moneo/moneo_config.json /opt/azurehpc/tools/Moneo/moneo_config.json

# Start the service
/opt/azurehpc/tools/Moneo/linux_service/start_moneo_services.sh

