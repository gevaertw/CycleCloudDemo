## Shebang
#!/bin/bash

## Resource Request
#SBATCH --job-name=singlecpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

## Your script goes here
srun echo "Start process"
srun hostname
srun sleep 30
srun echo "End process"