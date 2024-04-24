#!/bin/bash

# This script will be used to execute both gui_settings.sh as well backend_settings.sh in one go.

# Directories for temporary script storage.
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Variable assignment for URLs.
GUI_SCRIPT_URL="https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/3.4/bash/gui_settings.sh"
BACKEND_SETTINGS_URL="https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/3.4/bash/backend_settings.sh"

# Function to download and execute a script.
execute_script() {
    local url=$1
    local script_name=$2
    local use_sudo=$3

    echo "Downloading $script_name..."
    curl -sSL "$url" -o "$script_name"

    if [ $? -eq 0 ]; then
        echo "$script_name was downloaded successfully."
        echo "Executing $script_name..."

        if [ "$use_sudo" = true ]; then
            sudo bash "$script_name"
        else
            bash "$script_name"
        fi
    else
        echo "Failed to download $script_name."
        exit 1
    fi
}

# Execute scripts.
execute_script "$GUI_SCRIPT_URL" "user_gui_settings.sh" false
execute_script "$BACKEND_SETTINGS_URL" "backend_settings.sh" true

# Cleanup
cd -
rm -r "$TMP_DIR"



