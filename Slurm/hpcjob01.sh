#!/bin/bash

iteration=$1
sleeptime=$2

# This is the actual job that will be run by Slurm
echo "Start Slurm Test at $(date)"
echo Iteration ${iteration} : Slurm process $SLURM_PROCID is running on node $(hostname) and will wait for ${sleeptime} .
sleep $sleeptime
echo "End Slurm Test at $(date)"