#Each job takes a lot of time to complete so its pefect for testing the Slurm queue, and to demonstrate / test what happes when a node fails
## Shebang
#!/bin/bash

## Job Steps
## Each sbatch line in the loop is considered a new job to slurm!
## a range of 1 to 1 000 000 000 takes 1h30m to complete on standard machine

sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 1 1000000000
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 1000000000 2000000000
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 2000000000 3000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 3000000000 4000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 4000000000 5000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 5000000000 6000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 6000000000 7000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 7000000000 8000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 8000000000 9000000000 
sbatch  --job-name=PrimeNumbers --output=hpcjob03_output_%j.txt --error=hpcjob03_error_%j.txt ./hpcjob03.sh 9000000000 10000000000
