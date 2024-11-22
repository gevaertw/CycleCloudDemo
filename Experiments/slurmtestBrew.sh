#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest05-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=Prime_Parallel_short_$TIMESTAMP
PARTITIONNAME=htc
MINNODES=5
MAXNODES=10

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."

# Job submission
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --nodes=$MINNODES --array=0-99 --partition=$PARTITIONNAME ./hpcjob05_short.sh 
