#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}   📊 Installing TableGen Linux          ${NC}"
echo -e "${BLUE}=========================================${NC}"

mkdir -p "$HOME/.local/bin"
cp -f "$(dirname "$0")/bin/tablegen" "$HOME/.local/bin/tablegen"
chmod +x "$HOME/.local/bin/tablegen"
ln -sf "$HOME/.local/bin/tablegen" "$HOME/.local/bin/table"

mkdir -p "$HOME/.local/share/applications"
cp -f "$(dirname "$0")/assets/tablegen.desktop" "$HOME/.local/share/applications/tablegen.desktop"
command -v update-desktop-database &>/dev/null && update-desktop-database "$HOME/.local/share/applications" || true

# Setup GNOME Shortcut (Alt+T for Table Converter)
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ] || [ "$DESKTOP_SESSION" = "ubuntu" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
    echo -e "${YELLOW}Configuring GNOME global shortcuts (Alt+T)...${NC}"
    EXISTING=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | tr -d '@as ' | sed 's/\[//;s/\]//')
    KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/tablegen0/"
    
    if [[ ! "$EXISTING" =~ "tablegen0" ]]; then
        if [ -z "$EXISTING" ]; then NEW_LIST="['$KEY_PATH']"
        else NEW_LIST="[$(echo "$EXISTING" | sed "s/]$//"), '$KEY_PATH']"
        fi
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST" || true
    fi

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH name "TableGen - Table Converter (Alt+T)" || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH command "$HOME/.local/bin/tablegen" || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH binding "<Alt>t" || true
fi

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}   ✅ TableGen Installed Successfully!   ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "1. Copy any cells from Excel/Sheets, CSV, or Markdown."
echo -e "2. Press ${YELLOW}Alt + T${NC} to convert and paste immediately!"
