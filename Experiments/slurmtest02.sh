#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest02-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=Snorlax

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."

## how long do you want the job to run (to sleep)?
jobruntime=10m

## Each sbatch line in the loop is considered a new job to slurm!
for i in {1..8}
do
  sbatch --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --exclusive  ./hpcjob02.sh $i $jobruntime
done
