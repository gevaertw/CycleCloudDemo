#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest04-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=PrimeNumbers_Parallel
PARTITIONNAME=htc

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."


# Job Steps
# Each sbatch line in the loop is considered a new job to slurm!  its actualy the same as slurmtest03.sh but with subtasks


sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --array=0-999 --partition=$PARTITIONNAME ./hpcjob05.sh $startnumber 

