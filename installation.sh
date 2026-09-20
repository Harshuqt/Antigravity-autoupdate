#!/bin/bash
set -e

echo "======================================"
echo " Antigravity Installer & Setup        "
echo "======================================"

# 1. Run update.sh
echo "[1/3] Running updater script..."
if [ -f "./update.sh" ]; then
    ./update.sh
else
    echo "Error: update.sh not found in the current directory."
    exit 1
fi

# 2. Download Icon
echo "[2/3] Setting up Antigravity icon..."
ICON_DIR="$HOME/.local/share/icons"
ICON_PATH="$ICON_DIR/antigravity.png"
mkdir -p "$ICON_DIR"

if [ ! -f "$ICON_PATH" ]; then
    curl -s -o "$ICON_PATH" "https://antigravity.google/assets/image/antigravity-logo.png"
fi

# 3. Create Desktop Shortcut
echo "[3/3] Creating Desktop and Application Menu shortcuts..."
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
SHORTCUT_PATH="$DESKTOP_DIR/antigravity.desktop"
MENU_PATH="$HOME/.local/share/applications/antigravity.desktop"

DESKTOP_ENTRY="[Desktop Entry]
Name=Google Antigravity
Comment=Agent-First IDE by Google
Exec=/usr/share/antigravity/antigravity %U
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=antigravity"

# Write to Desktop
echo "$DESKTOP_ENTRY" > "$SHORTCUT_PATH"
chmod +x "$SHORTCUT_PATH"

# Write to Application Menu
mkdir -p "$HOME/.local/share/applications"
echo "$DESKTOP_ENTRY" > "$MENU_PATH"
chmod +x "$MENU_PATH"

# Update desktop database so the icon appears immediately in the app menu
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications"
fi

echo "======================================"
echo " Setup Complete!                      "
echo " You can now launch Antigravity from  "
echo " your Desktop or your Application menu."
echo "======================================"
