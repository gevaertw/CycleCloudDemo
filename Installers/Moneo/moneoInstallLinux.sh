#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)
# based on https://github.com/Azure/Moneo/blob/main/docs/HeadlessDeployment.md

# Run this script on all nodes in the scale set, by starting it from the cyclecloud cloud init script.  It assumes that the azure install part, where you add the user assigned identity to the VMSS has already been done.

# Copy the config files from the NFS share and start the service.  If you have named the NFS share differently or you gip cloned in another directory, you will need to adjust the paths. 
yes | \cp /cyclenfs/CycleCloudDemo/Installers/Moneo/moneo_config.json /opt/azurehpc/tools/Moneo/moneo_config.json
yes | \cp /cyclenfs/CycleCloudDemo/Installers/Moneo/moneo@.service /etc/systemd/system/moneo@.service
yes | \cp /cyclenfs/CycleCloudDemo/Installers/Moneo/moneo_publisher.service /etc/systemd/system/moneo_publisher.service

# Start the service delayed by 5 minutes to allow the VM to fully boot up and to avoid that cluster init will kill the service by restarting the network, altough this works I don't think it's nice
at now + 2 minutes -f /opt/azurehpc/tools/Moneo/linux_service/start_moneo_services.sh


# fix in systemctl
# /opt/azurehpc/tools/Moneo/linux_service/start_moneo_services.sh

# systemctl enable moneo@.service
# systemctl enable moneo_publisher.service

# systemctl start  moneo@.service
# systemctl start  moneo_publisher.service

# try fix with reboot after cloud init

