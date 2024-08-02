#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

#-------------------------------------------------
#Alternative: # https://openfoam.org/download/10-ubuntu/
#-------------------------------------------------

sh -c "wget -O - https://dl.openfoam.org/gpg.key > /etc/apt/trusted.gpg.d/openfoam.asc"
add-apt-repository http://dl.openfoam.org/ubuntu --yes
apt-get update
NEEDRESTART_MODE=a apt-get install openfoam12 --yes
NEEDRESTART_MODE=a apt-get install gnome-panel gnome-flashback gnome-session-flashback --yes
# NEEDRESTART_MODE=a apt-get install indicator-applet-appmenu --yes

echo "source /opt/openfoam12/etc/bashrc" >> ~/.bashrc
echo "source /opt/openfoam12/etc/bashrc" >> /etc/bashrc

simpleFoam -help