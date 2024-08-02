#!/bin/bash

# https://openfoam.org/download/source/

# Installing Software for Compilation, etc.
dnf -y install flex
dnf -y install cmake
# MPI not found yet
yum -y install paraview



# Downloading the OpenFOAM Source Code.
git clone https://github.com/OpenFOAM/OpenFOAM-12.git
git clone https://github.com/OpenFOAM/ThirdParty-12.git

# Setting the OpenFOAM Environment.
source $HOME/OpenFOAM-12/etc/bashrc
source $HOME/.bashrc


# Installing Third Party Software.
mkdir -p $HOME/.OpenFOAM 
echo "export SCOTCH_VERSION=6.0.6" >> $HOME/.OpenFOAM/prefs.sh 
echo "export ZOLTAN_VERSION=3.83" >> $HOME/.OpenFOAM/prefs.sh

# Compiling OpenFOAM.

# this is no good... ubuntu..

