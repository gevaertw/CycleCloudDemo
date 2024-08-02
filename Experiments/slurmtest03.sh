#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest03-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=PrimeNumbers
PARTITIONNAME=hpc

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."



# Job Steps
# Each sbatch line in the loop is considered a new job to slurm!
# a range of 1 to 1 000 000 000 takes more than 6h to complete (witch makes it perfect for spot eveiction testing)
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

