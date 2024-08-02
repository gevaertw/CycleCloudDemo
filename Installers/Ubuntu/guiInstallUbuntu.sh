#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

NEEDRESTART_MODE=a apt-get install ubuntu-desktop --yes
NEEDRESTART_MODE=a apt-get install xrdp --yes
adduser xrdp ssl-cert
