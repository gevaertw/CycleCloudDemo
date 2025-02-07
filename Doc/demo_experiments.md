# Test the cluster
## Start the cluster
- Hit the start button from the cluster, after 5 minutes it should be ready.  
- If you have errors, review the logs in the CycleCloud server, if the cluster is running, you can log on to the scheduler node using ssh and check error logs:
  - Cloud init logs: /var/log/cloud-init-output.log
  - slurm install logs: /var/log/azure-slurm-install.log

## The most basic test
On the sheduler execute following command:
```bash
srun -N5 -l /bin/hostname
```
This will start 5 tasks on the cluster, and return the hostname of the node where the task is running.
## Prepare for testing longer running jobs from the NFS share
These steps are executed only once per deployment of a cyclecloud environment
- Log on to the scheduler node using ssh
- Run the commands in the script to prepare the environment for testing.  The script is in this repo, not on the server.
- 


## Run an experiment
- From the management workstation, log on to the scheduler node using ssh
- In the folder /Experiments you will find some scripts called slurmtest0N.sh
  - slurmtest01.sh is a simple script that will run a single job on the cluster using srun
  - slurmtest02.sh is a more complex script that will run multiple jobs on the cluster using sbatch
  - slurmtest03.sh is a script that will start multiple batch jobs, it calculates prime numbers, and on regular VM's it will run for a long time, when investigating 1.000.000.000 numbers.
  - slurmtest04.sh is a script that will start multiple batch jobs.  Its the same as slurmtest03.sh but instead of 10 big jobs, it will start 1000 small jobs.
  - hpcjob01.sh is the actual job that will be run on the cluster, started by the slurmtest01.sh script
  - hpcjob02.sh is the actual job that will be run on the cluster, started by the slurmtest02.sh script
  - prime.py is the python script that will be run by the hpcjob03.sh and hpcjob04.sh script
- Edit the script so it has the parameters you want (optional)  
- Run the script, it should create HPC nodes & start a job on the cluster.  when the job is done you find the results (or errors) in the results folder.