#!/bin/bash

# This script handles updates between Odoo Mint 3.0 and Odoo Mint 5.0

# Installing Thunderbird, Keepassx, Slimbook, Spotify, Diodon GTK+ Clipboard Manager, Obsidian, CPU-X, Crow Translate, .

# Ensure the script is run as root or with sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges."
    exit 1
fi

# Function to handle the installation process.
install_package () {
    echo "Installing $1..."
    apt install "$1" -y
    if [ $? -ne 0 ]; then
        echo "Failed to install $1...">&2
        exit 1
    fi
}

# Function to update packages.
update_packages () {
    echo "Updating packages..."
    apt update
    if [ $? -ne 0 ]; then
        echo "Package update failed. Check your network connection or repository settings...">&2
        exit 1
    fi
}

is_installed () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

update_packages

#Installation of applications
for pkg in thunderbird keepassx diodon  cpu-x; do
    if [ $(is_installed $pkg) -eq 0 ]; then
        install_package $pkg
    else
        echo "$pkg is already installed, skipping..."
    fi
done

# Add slimbook repository
echo "Adding Slimbook repository..."
add-apt-repository ppa:slimbook/slimbook -y
update_packages
if [ $(is_installed slimbookbattery) -eq 0 ]; then
    install_package slimbookbattery
else
    echo "Slimbook Battery is already installed, skipping..."
fi

# Add Spotify repository and install
echo "Downloading Spotify signed GPG keys..."
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
if [ $? -ne 0 ]; then
    echo "Failed to download Spotify GPG keys..." >&2
    exit 1
fi

echo "Adding Spotify repository..."
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
update_packages  # Update after adding Spotify repository
if [ $(is_installed spotify-client) -eq 0 ]; then
    install_package spotify-client
else
    echo "Spotify Client is already installed, skipping..."
fi

# Download Obsidian Deb file.
echo "Download Obsidian Deb file..."
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb

# Install the package.
dpkg -i obsidian_1.5.12_amd64.deb
apt-get install -f

# Download and Install Crow Translate. 

# Add the Crow Translate PPA.
echo "Adding the Crow Translate PPA..."
add-apt-repository ppa:jonmagon/crow-translate

echo "Updating packages..."
update_packages

echo "Installing Crow Translate..."
apt install crow-translate



echo "All installations completed successfully."


