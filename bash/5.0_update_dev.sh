#!/bin/bash

# This script handles updates and installations for updates made between version 3.0 and 5.2 of Odoo Mint.

# Changes made:
# Install Thunderbird
# Install Keepassx
# Install Slimbook Battery
# Install Spotify
# Install Diodon Clipboard Manager
# Install Obsidian
# Install CPU-X
# Install Crow Translate 

# Ensure the script is run with root or with sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges..."
    exit 1
fi

# Function to handle the installation process.
install_package () {
    echo "Installing $1..."
    apt install "$1" -y
    if [ $? -ne 0 ]; then
        echo "Failed to install $1..." >&2
        exit 1
    fi
}

# Function to update packages.
update_packages () {
    echo "Updating packages..."
    apt update
    if [ $? -ne 0 ]; then
        echo "Package update failed. Check your network connection or repository settings..." >&2
        exit 1
    fi
    
    apt upgrade -y
    if [ $? -ne 0 ]; then
        echo "Package upgrade failed..." >&2
        exit 1
    fi
}

# Function to check if a package is installed.
is_installed () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

# Function to add a repository.
add_repository () {
    echo "Adding repository: $1"
    add-apt-repository "$1" -y
    update_packages
}

# Function to download and install a deb file.
install_deb () {
    echo "Downloading $1..."
    wget -q "$1" -O /tmp/temp_package.deb
    if [ $? -ne 0 ]; then
        echo "Failed to download $1..." >&2
        exit 1
    fi

    echo "Installing downloaded package..."
    dpkg -i /tmp/temp_package.deb
    apt-get install -f -y
}

# Update and upgrade existing packages.
update_packages

# Installation of common packages.
packages=(thunderbird keepassx diodon cpu-x)
for pkg in "${packages[@]}"; do
    if [ $(is_installed $pkg) -eq 0 ]; then
        install_package $pkg
    else
        echo "$pkg is already installed, skipping..."
    fi
done

# Slimbook repository and package.
if [ $(is_installed slimbookbattery) -eq 0 ]; then
    add_repository "ppa:slimbook/slimbook"
    install_package slimbookbattery
else
    echo "Slimbook Battery is already installed, skipping..."
fi

# Spotify repository and package.
if [ $(is_installed spotify-client) -eq 0 ]; then
    echo "Adding Spotify repository..."
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo tee /etc/apt/trusted.gpg.d/spotify.gpg > /dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to download Spotify GPG keys..." >&2
        exit 1
    fi
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    update_packages
    install_package spotify-client
else
    echo "Spotify Client is already installed, skipping..."
fi

# Obsidian Installation
if [ $(is_installed obsidian) -eq 0 ]; then
    install_deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb"
else
    echo "Obsidian is already installed, skipping..."
fi

# Crow Translate repository and package.
if [ $(is_installed crow-translate) -eq 0 ]; then
    echo "Adding Crow Translate repository key..."
    wget -qO- https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC2B0E8C0D58C0CED | sudo tee /etc/apt/trusted.gpg.d/crow-translate.gpg > /dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to add Crow Translate GPG key..." >&2
        exit 1
    fi
    add_repository "ppa:jonmagon/crow-translate"
    install_package crow-translate
else
    echo "Crow Translate is already installed, skipping..."
fi

echo "All installations completed successfully."
