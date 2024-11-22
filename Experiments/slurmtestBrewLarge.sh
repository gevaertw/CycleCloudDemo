#!/bin/bash
TESTNAME=BrewLarge

RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
JOBNAME=$TESTNAME_$TIMESTAMP
FULLOUTPUTPATH=$RESULTFOLDER/$JOBNAME

PARTITIONNAME=htc
MINNODES=5
MAXNODES=10

mkdir $FULLOUTPUTPATH
echo "Results are stored in ${FULLOUTPUTPATH}."

# Job submission
sbatch  --job-name=$JOBNAME \
    --output=$FULLOUTPUTPATH/%x_%j_out.txt \
    --error=$FULLOUTPUTPATH/%x_%j_err.txt \
    --cpus-per-task=1  \
    --nodes=$MINNODES-$MAXNODES  \
    --array=0-999 \
    --partition=$PARTITIONNAME  \
    ./hpcjob05.sh
 
