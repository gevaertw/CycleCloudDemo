Use at your own risk responsibility etc.  For POC purposes only, designed for functionality, not security.  Im not giving support, nor does my employer.
# What does this do? 
Deploy a Cyclecloud cluster on Azure with additional components for simplified management and testing.
# Known issue's
- There is a dependency problem in the deployment script, if you run the script 2 times you will get a working environment.  

# Architecture overview
<img src="./Doc/draw/overview.drawio.svg">

# Pre deployment tasks:
- Download everything in this repo to a local folder.
- Make sure to have powershell and az cli installed.
- Review the CycleCloudParameters.json file and adjust the settings to your needs.  Make sure change the default password for the CycleCloud user.
- Have onwer rights on the Azure subscription you are gooing to deploy to.


# Deployment tasks:
- Log in into Azure using Azure cli
- Open a powershell window and navigate to the folder where you downloaded the files.
- Execute the deploy.ps1 script


# Post deployment tasks:
- Log on to the management Windows 11 workstation and run the following command:

```
ssh-keygen
type .\.ssh\id_rsa.pub
```
copy the public key, and enter it when asked during the first deploy of CycleCloud.

## CycleCloud setup
- Open a browser and go to the CycleCloud server's IP address using http (not https) 
- Choose a site name 
- Enter the user information, including the public key just created.
- In the subscription wizard
  - Select the subscription you used for the azure deployment
  - The region where you want to deploy the resources, must be the same region as the rest of the Azure resources  
  - Select the storage account created earlier, witch name starts with lock
  - Accept the marketplace terms

## Initialize the CycleCloud CLI and api
Log on to the CycleCloud server using Bastion and run the following command:

```bash 
cyclecloud initialize
```

This command will create a .cycle folder with the config.ini file in the CycleCloud user's home directory.  From this point you can work with the CLI and the API on the CycleCloud server.



# Create a Slurm cluster

## About
- Give the thing a name

## Required settings
### Virtual Machines
- Select a region, us the same as the region where you deployed CycleCloud
- Select your VM types for the scheduler and the HPC nodes, in this window you can also select spot instances for the HPC nodes.
### Auto-Scaling
- Set core limits
### Networking
- Select a network that is big enough to hold the amount of VMs
### High Availability
- Leave default

## Network attached storage
- Leave everything default

## Advanced settings
### Slurm Settings
- Leave default
### Azure Settings
- Leave default 
### Software
- Select the OS, and the version, this POC assumes Alma Linux (leave default for now).  Ubuntu should not given any issues, but the test scripts are not tested on Ubuntu.
- Check the "Disable PMC" box, this will exclude MSFT repositories, currently there is a bug in one of teh repo's that will cause the install to fail.  
### Node Health Checks
- Leave default
### Advanced Networking
- Remove the box "Return Proxy"
- Remove the box "Use Public Head Node"

## Security
### Security Settings
- Leave default
### Encryption Settings
- Leave default

## Cloud-init
- Disable apply to all, the individual node types can now have their own cloud-init settings
- Paste the content from the corresponding file in each cloud-init field
  - Scheduler: CycleCloudSlurmClusterSheduler.yaml
  - HPC: CycleCloudSlurmClusterHPC.yaml

# Test the cluster
## Start the cluster
- Hit the start button from the cluster, after 5 minutes it should be ready.  
- If you have errors, review the logs in the CycleCloud server, if the cluster is running, you can log on to the scheduler node using ssh and check error logs:
  - Cloud init logs: /var/log/cloud-init-output.log
  - slurm install logs: /var/log/azure-slurm-install.log

## Run an experiment
- From the management workstation, log on to the scheduler node using ssh
- In the folder /experiments you will find a script called slurmtest02.sh
- Edit the script so it has the parameters you want (optional)  
- Run the script, it should create HPC nodes & start a job on the cluster

# Stuff to know about
## Run, terminate, delete a cluster
- When you start a cluster, the scheduler node is created.  Under normal circumstances HPC nodes are only created when a job is submitted.  
- When you terminate the cluster, the HPC and scheduler nodes are deleted, but the schedulers disk remains.  
- When you delete the cluster, everything is deleted, including the scheduler disk.

