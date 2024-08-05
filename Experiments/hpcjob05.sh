#!/bin/bash

startnumber=$(( $SLURM_ARRAY_TASK_ID * 1000000 ))
endnumber=$(( ($SLURM_ARRAY_TASK_ID + 1) * 1000000 ))

# This is the actual job that will be run by Slurm
python3.9  ./prime.py $startnumber $endnumber
