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








