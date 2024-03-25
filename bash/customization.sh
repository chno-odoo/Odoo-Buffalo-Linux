#!/bin/bash

# This script will be used to add customization the Odoo Mint 2.0.

#Download the raw image files
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/odoo_logo.png -o $HOME/odoo_logo.png
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/Ologo1.png -o $HOME/OLogo1.png
curl -L https://raw.githubusercontent.com/chno-odoo/Odoo-Buffalo-Linux/5b5cb493fb4ab58e40ace10d1e88b0f57d2f27d7/images/odoo_logo_inverted.png -o $HOME/odoo_logo_inverted.png

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

# Add atera agent.
(sudo wget -O - "https://HelpdeskSupport1706554083638.servicedesk.atera.com/api/utils/AgentInstallScript/Linux/001Q3000006btKcIAI?customerId=7" | sudo bash)

# Map the print key to take a screenshot with flameshot.

# Remove the print standard print key keybinding.

gsettings set org.cinnamon.desktop.keybindings.media-keys screenshot "['']"

# Define the command to be executed when the Print key is pressed
command="flameshot gui"

# Define the key to be used for the screenshot (Print key is represented as "Print")
key="Print"

# Define the schema where the custom shortcut will be added
schema="org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/"

# Set the name, command and binding for the custom shortcut
gsettings set $schema name 'flameshot screenshot'
gsettings set $schema command "$command"
gsettings set $schema binding "$key"

# Map Super + L to lockscreen as default.

# Define the keybinding variable
keybinding="['<Super>l']"

# Define the command to lock the screen
command="gnome-screensaver-command --lock"

# Use gsettings to set the custom keybinding
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ name 'lock-screen'
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ command "$command"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ binding "$keybinding"

# Add the custom keybinding to the list of keybindings
gsettings set org.cinnamon.desktop.keybindings custom-list "['custom0' ,'custom1']"


