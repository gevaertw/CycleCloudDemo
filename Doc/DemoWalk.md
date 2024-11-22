- For sake of time, make sure that a brew cluster is already running and a brew calculation is available already
- Create a vanilla cluster
    - Show the cluster creation page
    - Create a new cluster called vanilla, add cloud init stuff to it
- Create a Custom cluster called brew
    - Create a new template called brew, with a few customizations like prefix etc
    - Create a new cluster called brew using the brew template and add the cloud init stuff to it
    - Show the template changes, find for tags like #brew in teh script code
- Start a calculation on brew
    - Use the brew script to start a calculation
    ```bash
    cd /cyclenfs/CycleCloudDemo/Experiments/
    ./slurmtestBrew.sh
    ```
    - Show the scripts + explain
    - Show how how nodes are added to the brew cluster



