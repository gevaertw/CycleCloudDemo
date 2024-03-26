## This script submits a $jobcount amount of jobs to slurm.  Define the amount of jobs and the $jobruntime runtime of the jobs in the other, non slurm parameters.

## Shebang
#!/bin/bash

## Slurm Parameters
#SBATCH --job-name=testJob
#SBATCH --exclusive
#SBATCH --output=testJob-%j.out
#SBATCH --error=testJobErrors-%j.out
#SBATCH --time=1-00:10:00
#SBATCH --ntasks=16
#SBATCH --ntasks-per-node=4
#SBATCH --nodes=4
#SBATCH --mem-per-cpu=500M

## Other, non Slurm parameters
## how long do you want the job to run?
jobruntime=6m
## How many jobs you want to launch?
jobcount=3

## Job Steps
## Each sbatch line in the loop is considered a new job to slurm!
srun echo "Start Slurm Test"
for i in {1..16}
do
  sbatch ./hpcjob01.sh $i $jobruntime
done
srun echo "End Slurm Test"