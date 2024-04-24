#!/bin/bash

startnumber=$1
endnumber=$2

# This is the actual job that will be run by Slurm
python  ./prime.py $startnumber $endnumber
