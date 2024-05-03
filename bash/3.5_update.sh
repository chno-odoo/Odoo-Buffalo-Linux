#!/bin/bash

# This script handles updates between Odoo Mint 3.4 and Odoo Mint 3.5.
# Installing Diodon GTK+ Clipboard Manager.

# Ensure the script is run as root or with sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges."
    exit 1
fi

# Update packages.
echo "Updating packages..."
apt update

# Install Diodon.
echo "Installing Diodon..."
apt install diodon -y
