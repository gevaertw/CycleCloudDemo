# root is assumed here.  (if running from cloud init, you are root)

dnf makecache --refresh
# install X11
dnf -y install xorg-x11-server-utils
dnf -y install xorg-x11-xauth
echo "X11Forwarding yes" > /etc/ssh/ssh_config.d/X11Forwarding.conf

# install Firefox
sudo dnf -y install firefox

# vs code
dnf makecache --refresh
dnf groupinstall "Development Tools"
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
dnf update
dnf install code

# restart some servcies
systemctl restart sshd