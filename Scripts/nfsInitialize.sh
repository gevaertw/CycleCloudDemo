# to be executed once per deploylment, perhaps on the fist head node of the first cluster, creates the nfs share and populates it with some experiments

chmod -R 755 /cyclenfs
mkdir -p /cyclenfs/software
mkdir -p /cyclenfs/experiments
mkdir -p /cyclenfs/results
chown -R cycleadmin:cyclecloud /cyclenfs/software
chown -R cycleadmin:cyclecloud /cyclenfs/experiments
chown -R cycleadmin:cyclecloud /cyclenfs/results

# Get the slurm experiments
cd /cyclenfs/experiments
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest01.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest02.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/slurmtest03.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob01.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob02.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/hpcjob03.sh
wget https://raw.githubusercontent.com/gevaertw/CycleCloudDemo/main/Experiments/prime.py
chmod +x *.sh
