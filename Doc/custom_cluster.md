# Customize a cluster
- Assumes you have the azurecyclecloud cli installed on the cyclecloud server.
- Check the cyclecloud locker used, and set it as default
- Commands & scripts need more work, but this is the general idea

## Before you start
- The whole customisation process is done on the cyclecloud server, start by connection over ssh to your server.  Alternatively you can use another VM with the CycleCloud cli installed.
- The next set of commands require AZ Copy to be installed on the CycleCloud server (or any other linux that you will use to execute the procedure).  This is installed by default, but only root has access.  So let's change that
```bash
sudo chmod 755 /usr/local/cyclecloud-cli/embedded/bin/azcopy
```

## Create a new project 
- Pre configure the locker

```bash
PROJECTNAME=BrewCluster
# Get the locker name
LOCKER=$(cyclecloud locker list | cut -d' ' -f1)
cyclecloud project init $PROJECTNAME
cd $PROJECTNAME
cyclecloud project default_locker $LOCKER --global
cyclecloud project fetch https://github.com/Azure/cyclecloud-slurm ./
curl -o icon.png https://www.clipartbest.com/cliparts/7Ta/6bd/7Ta6bdAbc.png 

```
- Stay in the same directory or adapt the paths in the below commands
- Edit the template file in ./templates/slurm.txt to your liking by editing the txt file, don't rename the file, don't change cluster names, and watch out for indentation etc.
- Instead of editing the file you can download the file from the repo and overwrite the existing file.
- Once the template is ready, import it to cyclecloud, with following commands:

```bash 
cyclecloud import_template --force -f ./templates/slurm.txt
cyclecloud project upload
cd ..
```
## delete the cluster template
- If you want to delete the cluster template, you can do so with the following command:

```bash
cyclecloud delete_template Slurm
```

Read more about the cyclecloud commands here: https://learn.microsoft.com/en-us/azure/cyclecloud/cli?view=cyclecloud-8