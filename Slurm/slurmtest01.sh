#!/bin/bash

srun  --job-name=hpcjob01 --output=hpcjob01_output.txt --error=hpcjob01_error.txt --label --nodes=1 --ntasks=1 --cpus-per-task=2 --time=1:00:00 ./hpcjob01.sh
