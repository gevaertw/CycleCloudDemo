# bin/bash
# Run this script to install the jupiter server.  Root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

# Install conda
dnf -y install conda

# install jupyter (no root required)
dnf -y install nodejs
pip3 install jupyterlab
pip3 install jupyterlab_slurm








