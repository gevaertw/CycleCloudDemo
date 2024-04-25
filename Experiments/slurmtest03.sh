## This script submits a $jobcount amount of jobs to slurm.  Define the amount of jobs and the $jobruntime runtime of the jobs in the other, non slurm parameters.
## each job takes a lot of time to complete so its pefect for testing the Slurm queue, and to demonstrate / test what happes when a node fails
## Shebang
#!/bin/bash

## Slurm Parameters
#SBATCH --job-name=testJob
#SBATCH --exclusive
#SBATCH --output=testJob-%j.out
#SBATCH --error=testJobErrors-%j.out
#SBATCH --time=1-00:10:00
#SBATCH --ntasks=10
#SBATCH --ntasks-per-node=2
#SBATCH --nodes=5
#SBATCH --mem-per-cpu=500M
echo "Slurm Test based on sbatch that creates 4 nodes with 2 tasks per node and 8 tasks in total."


## Job Steps
## Each sbatch line in the loop is considered a new job to slurm!
## a range of 1 to 1 000 000 000 takes 1h30m to complete on standard machine
echo "Start Slurm Test"
sbatch  ./hpcjob03.sh 1 1000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 1000000 2000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 2000000 3000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 3000000 4000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 4000000 5000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 5000000 6000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 6000000 7000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 7000000 8000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 8000000 9000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
sbatch  ./hpcjob03.sh 9000000 10000000 --output=hpcjob03_output.txt --error=hpcjob03_error.txt
echo "End Slurm Test"