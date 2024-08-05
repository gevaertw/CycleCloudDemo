#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest04-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=Prime_Parallel_short_$TIMESTAMP
PARTITIONNAME=htc

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."


# Job Steps
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --array=0-99 --partition=$PARTITIONNAME ./hpcjob05_short.sh $startnumber 

