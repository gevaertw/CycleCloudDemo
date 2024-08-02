#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

dnf makecache --refresh
# install X11
dnf -y install xorg-x11-server-utils
dnf -y install xorg-x11-xauth
echo "X11Forwarding yes" > /etc/ssh/ssh_config.d/X11Forwarding.conf

# install Firefox
dnf -y install firefox

# install vscode (not working yet) 
dnf makecache --refresh
dnf -y groupinstall "Development Tools"
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
dnf -y install code

# restart some servcies
systemctl restart sshd