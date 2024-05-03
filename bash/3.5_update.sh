#!/bin/bash

# This script handles updates between Odoo Mint 2.0 and Odoo Mint 3.2.
# It installs Thunderbird, Keepassx, Slimbook Battery, and Spotify-Client.

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
