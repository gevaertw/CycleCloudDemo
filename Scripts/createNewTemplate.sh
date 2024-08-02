#!/bin/bash

# Assumes you have the azurecyclecloud cli installed on the cyclecloud server.

# Download an existing project to the current folder
mkdir -p ./cyclecloudprojects
cd ./cyclecloudprojects
mkdir -p ./customSlurm
cd ./customSlurm

cyclecloud project fetch https://github.com/Azure/cyclecloud-slurm ./


# Edit the template file to your liking by editing the txt file, don't rename the file, dont change cluster names, etc.
rm ./templates/slurm.txt
nano ./templates/slurm.txt
# or
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/CycleTemplates/slurm.txt -O ./templates/slurm.txt

#once the template is ready, import it to cyclecloud
cyclecloud import_template --force -f ./templates/slurm.txt
cyclecloud project upload
