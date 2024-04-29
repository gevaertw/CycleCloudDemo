#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest01-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=PrimeNumbers
PARTITIONNAME=HTC

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."



# Job Steps
# Each sbatch line in the loop is considered a new job to slurm!
# a range of 1 to 1 000 000 000 takes more than 2h to complete
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 1 1000000000
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 1000000000 2000000000
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 2000000000 3000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 3000000000 4000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 4000000000 5000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 5000000000 6000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 6000000000 7000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 7000000000 8000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 8000000000 9000000000 
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 9000000000 10000000000


# this is a faster version with less numbers to calculate takes about 25 minutes to complete
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 1 10000000
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 10000000 20000000
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 20000000 30000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 30000000 40000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 40000000 50000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 50000000 60000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 60000000 70000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 70000000 80000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 80000000 90000000 
# sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh 90000000 100000000