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

# Add applications to the dock.

# Define the applications to be added to the dock
apps=("nemo" "org.gnome.Terminal" "discord" "google-chrome" "code" "simplescreenrecorder" "org.flameshot.Flameshot" "diodon" "libreoffice")

# Define the path to the dock items directory
dockItemsDir=~/.config/plank/dock1/launchers

# Loop through each application
for app in "${apps[@]}"
do
  # Create a .dockitem file for the application
  echo "[PlankItemsDockItemPreferences]" > $dockItemsDir/$app.dockitem
  echo "Launcher=file:///usr/share/applications/$app.desktop" >> $dockItemsDir/$app.dockitem
done

# Restart Plank to apply the changes
killall plank
nohup plank > /dev/null 2>&1 &

# Map the print key to take a screenshot with flameshot.

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
command="['gnome-screensaver-command --lock']"

# Use gsettings to set the custom keybinding
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ name 'lock-screen'
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ command "$command"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ binding "$keybinding"

# Add the custom keybinding to the list of keybindings
gsettings set org.cinnamon.desktop.keybindings custom-list "['custom0' ,'custom1']"

# Set the Panel Icon to a custom image.

# Define the path to the image
image_path="/home/$USER/Ologo1.png"

# Check if the image file exists
if [ ! -f "$image_path" ]; then
    echo "Image file does not exist"
    exit 1
fi

# Define the path to the icon file
icon_path="/usr/share/icons/Mint-Y/apps/48/start-here.svg"

# Check if the icon file exists
if [ ! -f "$icon_path" ]; then
    echo "Icon file does not exist"
    exit 1
fi

# Backup the original icon
cp $icon_path "${icon_path}.bak"

# Replace the icon with the new image
cp $image_path $icon_path

# Restart the panel to apply the changes
killall -SIGQUIT cinnamon-panel

echo "Panel icon changed successfully"

