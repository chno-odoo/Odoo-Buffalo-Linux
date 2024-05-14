#!/bin/bash

# This script will be used to make the change from Blueman Bluetooth Manager to Bluetuith Bluetooth Manager.

# Variables for Bluetuith
B=bluetuith
V=1.0.9
L=Linux_x86_64.tar.gz
URL="https://github.com/darkhz/bluetuith/releases/download/v0.2.2/bluetuith_0.2.2_Linux_x86_64.tar.gz"

# Function to check if a command succeeded
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

# Download and Install Bluetuith
echo "Downloading Bluetuith..."
wget $URL -O "/tmp/$B.tar.gz"
check_success "Downloading Bluetuith failed."

echo "Installing Bluetuith..."
sudo tar -xf "/tmp/$B.tar.gz" -C /usr/local/bin/
check_success "Extracting Bluetuith failed."

sudo chmod +x /usr/local/bin/bluetuith
check_success "Setting permissions for Bluetuith failed."

# Verify Bluetuith installation
if [ ! -f /usr/local/bin/bluetuith ]; then
  echo "Error: Bluetuith installation failed."
  exit 1
fi

# Remove Blueman
echo "Removing Blueman..."
sudo apt-get remove --purge -y blueman
check_success "Removing Blueman failed."

sudo apt-get autoremove -y
check_success "Autoremove failed."

# Create systemd service file for Bluetuith
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
check_success "Creating systemd service file failed."

# Enable Bluetuith Service
echo "Enabling Bluetuith service..."
sudo systemctl enable bluetuith.service
check_success "Enabling Bluetuith service failed."

# Disable Blueman autostart
echo "Disabling Blueman autostart..."
if [ -f /etc/xdg/autostart/blueman.desktop ]; then
  sudo rm /etc/xdg/autostart/blueman.desktop
  check_success "Disabling Blueman autostart failed."
fi

# Add Bluetuith to autostart
echo "Adding Bluetuith to autostart..."
sudo tee /etc/xdg/autostart/bluetuith.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Bluetuith
Exec=/usr/local/bin/bluetuith
X-GNOME-Autostart-enabled=true
EOF
check_success "Adding Bluetuith to autostart failed."

# Remove any residual Blueman files
echo "Cleaning up residual Blueman files..."
sudo rm -rf /usr/lib/python3/dist-packages/blueman*
sudo rm -rf /usr/share/blueman
sudo rm -rf /etc/blueman
check_success "Cleaning up residual Blueman files failed."

echo "Replacement of Blueman with Bluetuith is complete. Please reboot your system."
