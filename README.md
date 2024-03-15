Use at your own risk responsibility etc.  for POC purposes only, designed for functionality, not security.  Im not giving support, nor does my employer.

# Post deployment tasks:
Log on to the management windows 11 workstation and run the following command:
```
ssh-keygen
type .\.ssh\id_rsa.pub
```
copy the public key, and enter it when asked during the first deploy of Cyclecloud.


Log on to the cyclecloud server using Bastion and run the following command:
```bash 
cyclecloud initialize
```

This command will create a .cycle folder with the config.ini file in the cyclecloud user's home directory.  From this point you can work with the CLI and the API.

Open a browser and go to the cyclecloud server's IP address using http, enter the base information, including the public key just created.

# Create a slurm cluster

## About
-- Give the thing a name

## Required settings
- Select a region, us the same as teh region where you deployed cyclecloud
- Select your VM types
- Set core limits
- Select a network that is big enough to hold the VMs

## Network attached storage
- for now leave default

## Advanced settings
### Software
- Select the OS, and the version (leave default for now)

### Advanced Networking
- remove the box from use Public Head Node

## Security
leave all default

## Cloud-init
- Disable apply to all, the individual node types can now have their own cloud-init settings
- Paste the content from the corresponding file in each cloud-init field 

# Test the cluster
- Log on to the sheduler node using ssh
- In the folder /slurm/experiment01/ you will find a script called slurmtest02.sh  run the script, it should create HPC nodes & start a job on the cluster

