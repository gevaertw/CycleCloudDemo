#!/bin/bash

startnumber=$(( $1 * 1000 ))
endnumber=$(( ($1 + 1) * 1000 ))

# This is the actual job that will be run by Slurm
python3.9  ./prime.py $startnumber $endnumber
