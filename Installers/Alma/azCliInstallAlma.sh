#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)


# Update the AlmaLinux system
dnf update -y

# Install dependencies
dnf install ca-certificates curl lsb gnupg -y

# Download and install the Microsoft signing key
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/pki/rpm-gpg/microsoft.asc.gpg > /dev/null

# Add the Azure CLI software repository
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

# Update repository information
dnf check-update

# Install the azure-cli package
dnf install azure-cli -y

# Verify the installation
az --version

