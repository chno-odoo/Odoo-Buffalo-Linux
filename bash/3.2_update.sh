#!/bin/bash

# This script will be used to handle the updates that were made between Odoo Mint 2.0 and Odoo Mint 3.2.

# Summary of changes:
# Installed Thunderbird 
# Installed Keepassx 
# Installed Slimbook Battery
# Installed Spotify-Client
# Add Keepassx and Spotify-client to the favorite applications.


# Ensure the script is running as root or with sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "Script needs to be run as root or with sudo privileges."
    exit 1
fi

# Update package list.
echo "Updating packages..."
apt update
if [ $? -ne 0 ]; then
    echo "Packages were not able to be updated. Ensure you are connected to the internet or check your repository settings.">&2
    exit 1
fi

# Install Thunderbird
echo "Installing Thunderbird..."
apt install thunderbird -y
if [ $? -ne 0 ]; then
    echo "Failed to install Thunderbird...">&2
    exit 1
fi

# Install Keepassx
echo "Installing Keepassx..."
apt install keepassx -y
if [ $? -ne 0 ]; then
    echo "Failed to install Keepassx...">&2
    exit 1
fi

# Install Slimbook Battery
echo "Adding the Slimbook Battery repository..."
sudo add-apt-repository ppa:slimbook/slimbook -y
if [ $? -ne 0 ]; then
    echo "Failed to add the repository...">&2
    exit 1
fi

echo "Updating packages..."
apt update
if [ $? -ne 0 ]; then
    echo "Packages were not able to be updated. Ensure you are connected to the internet or check your repository settings.">&2
    exit 1
fi

echo "Installing Slimbook Battery..."
apt install slimbookbattery -y
if [ $? -ne 0 ]; then
    echo "Failed to install Slimbook Battery..."
    exit 1
fi

# Install Spotify-client from the official repository.
echo "Downloading Spotify signed GPG keys..."
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

echo "Adding Spotify Repository..."
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "Updating packages..."
apt-get update

echo "Installing Spotify..."
apt-get install spotify-client -y

gsettings.set.org.cinnamon favorite-apps "['keepassx.desktop', 'spotify.desktop', 'slimbookbattery.desktop']"








