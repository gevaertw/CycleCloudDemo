#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

yum groupinstall -y "Server with GUI" --skip-broken
yum install -y epel-release
systemctl disable firewalld --now

yum groupinstall -y xfce
yum install -y xrdp

echo "exec /usr/bin/xfce4-session" >> ~/.xinitrc
systemctl set-default graphical

systemctl enable xrdp
systemctl start xrdp

# vscode
dnf update -y
dnf groupinstall "Development Tools" -y
rpm --import https://packages.microsoft.com/keys/microsoft.asc
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
dnf update -y
dnf install code -y


