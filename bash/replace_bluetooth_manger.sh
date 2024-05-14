#!/bin/bash

# This script will be used to make the change from Blueman Bluetooth Manager to Bluetuith Bluetooth Manager.

# Variables for Bluetuith.
B=bluetuith
V=1.0.9
L=Linux_x86_64.tar.gz
URL="https://github.com/darkhz/$B/releases/download/v$V/$B"_"$V"_"$L"

# Download and Install Bluetuith.
echo "Downloading Bluetuith..."
wget $URL -O "/tmp/$B.tar.gz"

echo "Installing Bluetuith..."
sudo tar -xf "/tmp/$B.tar.gz" -C /usr/local/bin/
sudo chmod +x /usr/local/bin/bluetuith

# Remove Blueman.
echo "Removing Blueman..."
sudo apt-get remove --purge -y blueman
sudo apt-get autoremove -y

# Create systemd service file for Bluetuith.
echo "Creating systemd service file for Bluetuith..."
sudo tee /etc/systemd/system/bluetuith.service > /dev/null <<EOF
[Unit]
Description=Bluetuith Bluetooth Manager 
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/local/bin/bluetuith
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable Bluetuith Service.
echo "Enabling Bluetuith service..."
sudo systemctl enable bluetuith.service

# Disbale Blueman autostart. 
echo "Disabling Blueman autostart..."
if [ -f /etc/xdg/autostart/blueman.desktop ]; then
    sudo rm /etc/xdg/autostart/blueman.desktop
fi

# Add Bluetuith to autostart.
echo "Adding Bluetuith to autostart..."
sudo tee /etc/xdg/autostart/bluetuith.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Bluetuith
Exec=/usr/local/bin/bluetuith
X-GNOME-Autostart-enabled=true
EOF

# Remove any residual Blueman files.
echo "Cleaning up residual Blueman files..."
sudo rm -rf /usr/lib/python3/dist-packages/blueman*
sudo rm -rf /usr/share/blueman
sudo rm -rf /etc/blueman

echo "Replacement of Blueman with Bluetuith is complete. Please reboot your system."

