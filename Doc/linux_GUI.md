# Cloud-Init template for Linux GUI

## Introduction
Provides a template for creating a Linux VM with a desktop environment.  The template provides the xfce desktop, a lightweight desktop manager.   It also insatlls xrdp so you can connect to the desktop using an RDP client, witch is a bit more user friendly than x-forwarding over en ssh connection.  Everything is installed using the commands in the cloud-init script, where the GUI install script is called.

## Desktop user
The cyclecloud user cannot login to the desktop environment by default.  To create a desktop user add the user to the cloud init script.
- The password hash is created using the command ```openssl passwd -6 "DevDesk_45"``` where password is the password you want to use.

