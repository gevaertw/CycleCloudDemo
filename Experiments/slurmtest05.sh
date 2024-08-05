#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

JOBNAME=slurmtest05

TESTFOLDER=$JOBNAME-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
SLURMJOBNAME=Prime_Parallel_$TIMESTAMP

PARTITIONNAME=htc


# stuff that happens befor slurm is invloved
mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."


# Stuff that slurm does
# Each sbatch line in the loop is considered a new job to slurm!  its actualy the same as slurmtest03.sh but with subtasks
sbatch  --job-name=$SLURMJOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --array=0-999 --partition=$PARTITIONNAME ./hpcjob05.sh

