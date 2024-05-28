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
# Install App Image Launcher
# Install DeepL App Image

# Ensure the script is run with root or with sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges..."
    exit 1
fi

# Function to handle the installation process.
install_package () {
    local package=$1
    echo "Installing $package..."
    apt install "$package" -y
    if [ $? -ne 0 ]; then
        echo "Failed to install $package..." >&2
        exit 1
    fi
}

# Function to update packages.
update_packages () {
    echo "Updating packages..."
    apt update && apt upgrade -y
    if [ $? -ne 0 ]; then
        echo "Package update/upgrade failed. Check your network connection or repository settings..." >&2
        exit 1
    fi
}

# Function to check if a package is installed.
is_installed () {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed"
}

# Function to add a repository and update packages with retry mechanism.
add_repository () {
    local repo=$1
    echo "Adding repository: $repo"
    for i in {1..3}; do
        add-apt-repository "$repo" -y && update_packages && return 0
        echo "Attempt $i to add repository $repo failed. Retrying..."
        sleep 2
    done
    echo "Failed to add repository $repo after 3 attempts." >&2
    exit 1
}

# Function to download and install a deb file.
install_deb () {
    local url=$1
    echo "Downloading from $url..."
    wget -q "$url" -O /tmp/temp_package.deb
    if [ $? -ne 0 ]; then
        echo "Failed to download $url..." >&2
        exit 1
    fi

    echo "Installing downloaded package..."
    dpkg -i /tmp/temp_package.deb
    apt-get install -f -y
}

# Function to handle AppImage downloads.
install_appimage () {
    local url=$1
    local filename=$(basename "$url")
    echo "Downloading $filename..."
    wget -q "$url" -O "$filename"
    chmod +x "$filename"
    echo "$filename downloaded and made executable."
}

# Update and upgrade existing packages.
update_packages

# Installation of common packages.
packages=(thunderbird keepassx diodon cpu-x software-properties-common)
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
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
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

# App Image Launcher 
if [ $(is_installed appimagelauncher) -eq 0 ]; then
    add_repository "ppa:appimagelauncher-team/stable"
    install_package appimagelauncher
else
    echo "AppImageLauncher is already installed, skipping..."
fi

# DeepL AppImage Download
install_appimage "https://github.com/kumakichi/Deepl-linux-electron/releases/download/v1.4.3/Deepl-Linux-Electron-1.4.3.AppImage"

echo "All installations completed successfully."