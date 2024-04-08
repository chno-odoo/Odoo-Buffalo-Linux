#!/bin/bash

# This script will be used to create a temporary admin accouunt so that the original user can be modified.

# Ensure the script is run as sudo or root.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root or with sudo privileges." >&2
    exit 1
fi

# Add the user and modify the group assignment.
adduser tempadmin
usermod -aG sudo tempadmin

