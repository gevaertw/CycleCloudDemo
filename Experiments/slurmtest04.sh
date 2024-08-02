#!/bin/bash
RESULTFOLDER=/cyclenfs/results
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
TESTFOLDER=Slurmtest04-$TIMESTAMP
FULLPATH=$RESULTFOLDER/$TESTFOLDER
JOBNAME=PrimeNumbers
PARTITIONNAME=hpc

mkdir $FULLPATH
echo "Results are stored in ${FULLPATH}."


# Job Steps
# Each sbatch line in the loop is considered a new job to slurm!  its actualy the same as slurmtest03.sh but with more smaller chunks.

for i in {0..1000}
do
startnumber=$((i*1000000))
endnumber=$((startnumber+1000000))
sbatch  --job-name=$JOBNAME --output=$FULLPATH/%x_%j_out.txt --error=$FULLPATH/%x_%j_err.txt --cpus-per-task=1 --partition=$PARTITIONNAME ./hpcjob03.sh $startnumber $endnumber
done
