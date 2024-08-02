# bin/bash
# Rin this script to install the slurm integrated jupiter server.
conda create -y -n conda_jupiter python numpy pandasy
conda activate conda_jupiter

echo "c.ServerApp.allow_remote_access = True" >> ./.jupyter/jupyter_server_config.py

# generate a default password your_password (this is not safe)
dP=$(python3 -c "from jupyter_server.auth import passwd; print(passwd('your_password', algorithm='sha1'))")
jupyter lab --ServerApp.password=$dP --no-browser --ServerApp.port=9999 --ServerApp.allow_remote_access=True --ServerApp.ip=*

# start the tunnel on the client that has the web browser (not required if teh server listens on its IP address)
ssh -N -f -L 8888:localhost:8889 cycleadmin@10.16.13.5

# --- second method

## on the login node
sudo dnf update -y
# sudo dnf install python3 -y # already installed
wget -P ~/Downloads https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
cd ~/Downloads
bash Anaconda3-2024.06-1-Linux-x86_64.sh
conda install -c kaspermunch slurm-jupyter

# on the compute node
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda install -c kaspermunch slurm-jupyter
config-slurm-jupyter.sh


