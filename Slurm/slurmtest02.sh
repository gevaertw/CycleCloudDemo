## This script submits a $jobcount amount of jobs to slurm.  Define the amount of jobs and the $jobruntime runtime of the jobs in the other, non slurm parameters.

## Shebang
#!/bin/bash

## Slurm Parameters
#SBATCH --job-name=testJob
#SBATCH --exclusive
#SBATCH --output=testJob-%j.out
#SBATCH --error=testJobErrors-%j.out
#SBATCH --time=1-00:10:00
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=2
#SBATCH --nodes=4
#SBATCH --mem-per-cpu=500M
echo "Slurm Test based on sbatch that creates 4 nodes with 2 tasks per node and 8 tasks in total."
## Other, non Slurm parameters
## how long do you want the job to run?
jobruntime=10m
## How many jobs you want to launch?
jobcount=3

## Job Steps
## Each sbatch line in the loop is considered a new job to slurm!
srun echo "Start Slurm Test"
for i in {1..8}
do
  sbatch ./hpcjob02.sh $i $jobruntime --output=hpcjob02_output.txt --error=hpcjob02_error.txt
done
srun echo "End Slurm Test"