#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest01-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=Hello

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."


srun  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --label --nodes=1 --ntasks=1 --cpus-per-task=2 --time=1:00:00 ./hpcjob01.sh
