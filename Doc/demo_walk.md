# Preparations
- connect to the azure  bastion

az network bastion rdp --name "ccpoc-bas" --resource-group "ccpoc-net-rg" --target-resource-id "/subscriptions/151c387a-ea5a-460b-b019-b11a8bf9f04c/resourceGroups/ccpoc-base-rg/providers/Microsoft.Compute/virtualMachines/ccpoc-mgmt-vm"

- Check SAS token for the storage account!!!!
- For sake of time, make sure that a all -CB clusters are already running and a brew large calculation is running already
- Delete all results in the results folder
- Delete entire folder with templates


# Basic CycleCloud
- Create a Vanilla cluster
    - Show the cluster creation page
    - Create a new cluster called Vanilla
    - Run a first command on the vanilla cluster
```bash
srun --partition=hpc touch letsBrew.txt
ls
```
    - Show the scripts in vscode + explain
    - Show how how nodes are added to the brew cluster
    - Show the result of the calculation

# Automated deploy with cloud init
- Create a Pils cluster
    - Show the cluster creation page
    - Create a new cluster called Pils, add cloudinit stuff to it + explain
    - Run a first command on the vanilla cluster
```bash
cd /cyclenfs/CycleCloudDemo/Experiments/
./slurmtestBrew-hpc.sh
./slurmtestBrew-htc.sh
squeue

```

- show the results
```bash
cd /cyclenfs/results
```

# Customize CycleCloud Templates
- Create a Custom cluster called IPA
    - Create a new template called IPA
```bash
ssh 10.16.0.5

PROJECTNAME=IPA
LOCKER=$(cyclecloud locker list | cut -d' ' -f1)
cyclecloud project init $PROJECTNAME
cd $PROJECTNAME
cyclecloud project default_locker $LOCKER --global
cyclecloud project fetch https://github.com/Azure/cyclecloud-slurm ./


nano -c ./templates/slurm.txt
```
replace [cluster Slurm] with [cluster IPA]
on line 287 replace DefaultValue = Standard_F8s_v2


```bash 
cyclecloud import_template --force -f ./templates/slurm.txt
cyclecloud project upload
cd ..
```

    - Create a new cluster called brew using the IPA template
    - Start a calculation on brew

```bash
cd /cyclenfs/CycleCloudDemo/Experiments/
./slurmtestBrew-htc.sh
squeue
```
 
# Monitoring your runs
- Azure
    - Show the project on github  
    - Show the resources in the Azure portal
- Grafana
    - Show the monitoring of the pils cluster
    - Show a dashboard for the brew cluster

 



