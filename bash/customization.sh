#!/bin/bash

# Download the raw image files to the user's home directory
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/odoo_logo.png -o $HOME/odoo_logo.png
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/Ologo1.png -o $HOME/OLogo1.png
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/odoo_logo_inverted.png -o $HOME/odoo_logo_inverted.png

# NOTE: Ensure this script is executed as the target user for the following commands to apply to the correct graphical session.

# Set the downloaded image as the desktop background. 
gsettings set org.cinnamon.desktop.background picture-uri 'file://'$HOME'/odoo_logo.png'

# Set the background picture options.
gsettings set org.cinnamon.desktop.background picture-options 'centered'

# Set the background primary color.
gsettings set org.cinnamon.desktop.background primary-color '#FFFFFF'

# Set the Mouse Pointer.
gsettings set org.cinnamon.desktop.interface cursor-theme 'DMZ-White'

# Set application theme.
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-L-Dark-Purple'

# Set the icons theme.
gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-L-Purple'

# Set the desktop theme.
gsettings set org.cinnamon.theme name 'Mint-L-Purple'

# The script must ensure it is run with root or sudo privileges for system-wide changes.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges."
    exit 1
fi

# Add atera agent.
(wget -O - "https://HelpdeskSupport1706554083638.servicedesk.atera.com/api/utils/AgentInstallScript/Linux/001Q3000006btKcIAI?customerId=7" | bash)

# Install TLP for power optimization.
echo "Setting up TLP for power optimization..."
if ! command -v tlp &> /dev/null; then
    echo "TLP is not installed. Installing TLP..."
    add-apt-repository ppa:linrunner/tlp -y
    apt-get update
    apt-get install tlp tlp-rdw -y
    tlp start
    echo "TLP installation and setup completed."
else
    echo "TLP is already installed."
fi

# Set the swappiness value to improve hardware performance.
sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null

# Set the system limits and timezone.
echo "fs.file-max = 2097152" | sudo tee -a /etc/sysctl.conf > /dev/null
sudo timedatectl set-timezone America/New_York

