#!/bin/bash

# This script will be used to change the user account of the user that is automatically created when deploying from the FOG server.

# Ensure the script is run as sudo or root.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges." >&2
    exit 1
fi

# Ask for the quad.
echo -n "What is your Odoo quadgram? "
read QUAD

# Change the hostname to quad-laptop.
hostnamectl set-hostname "${QUAD}-laptop"

# Restart the NetworkManager.
systemctl restart NetworkManager

# Check if the hostname command was successful.
if [ $? -eq 0 ]; then
    echo "Hostname changed to ${QUAD}-laptop!"
else
    echo "Failed to change hostname to ${QUAD}-laptop." >&2
    exit 1
fi

# Ask for the current username.
echo -n "What is your current username? "
read CURRENT_USERNAME

# Check to ensure the current username exists. 
if ! id "$CURRENT_USERNAME" &>/dev/null; then
    echo "User ${CURRENT_USERNAME} does not exist.">&2
    exit 1
fi

# Ask for the new username.
echo -n "What would you like your username to be? "
read USERNAME

# Check to make sure the user does not already exist.
if id "${USERNAME}" &>/dev/null; then
    echo "User ${USERNAME} already exists." >&2
    exit 1
fi

# Modify the user to have their new username.
usermod -l $USERNAME -d /home/$USERNAME -m $CURRENT_USERNAME
if [ $? -eq 0 ]; then
    echo "Username changed to ${USERNAME}!"
else
    echo "Failed to change username." >&2
    exit 1
fi

# Require the user to change their password on the next login.
chage -d 0 "${USERNAME}"
if [ $? -eq 0 ]; then
    echo "User ${USERNAME} will be required to change their password on first login."
else
    echo "Failed to enforce password change on first login for ${USERNAME}." >&2
    exit 1
fi

