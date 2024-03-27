#!/bin/bash
# Your actual job commands go here
srun  --job-name=my_small_job --output=my_small_job_output.txt --nodes=1 --ntasks=1 --cpus-per-task=2 --time=1:00:00 ./hpcjob01.sh
