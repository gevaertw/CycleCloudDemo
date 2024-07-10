# to be executed once per deploylment, perhaps on the fist head node of the first cluster, creates the nfs share and populates it with some experiments and aditional scripts

sudo chmod -R 755 /cyclenfs
sudo chown -R cycleadmin:cyclecloud /cyclenfs
mkdir -p /cyclenfs/software

mkdir -p /cyclenfs/results
mkdir -p /cyclenfs/templates
# chown -R cycleadmin:cyclecloud /cyclenfs/software
# chown -R cycleadmin:cyclecloud /cyclenfs/experiments
# chown -R cycleadmin:cyclecloud /cyclenfs/results


# Get the slurm experiments
mkdir -p /cyclenfs/experiments
cd /cyclenfs/experiments
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest01.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest02.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest03.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest04.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob01.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob02.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob03.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/prime.py
chmod +x *.sh


# Get the additional scripts
mkdir -p /cyclenfs/software/scripts
cd /cyclenfs/software/scripts
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Scripts/guiInstall..sh
chmod +x *.sh