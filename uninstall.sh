#!/bin/bash
set -e

echo "======================================"
echo " Antigravity Uninstaller              "
echo "======================================"

# 1. Remove System Files
echo "[1/3] Removing Antigravity system files from /usr/share/antigravity..."
if [ -d "/usr/share/antigravity" ]; then
    echo "You may be prompted for your sudo password to remove system files."
    sudo rm -rf /usr/share/antigravity
    echo "System files removed."
else
    echo "System files not found, skipping."
fi

# 2. Remove Icon
echo "[2/3] Removing Antigravity icon..."
ICON_PATH="$HOME/.local/share/icons/antigravity.png"
if [ -f "$ICON_PATH" ]; then
    rm -f "$ICON_PATH"
    echo "Icon removed."
else
    echo "Icon not found, skipping."
fi

# 3. Remove Desktop Shortcuts
echo "[3/3] Removing shortcuts..."
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
SHORTCUT_PATH="$DESKTOP_DIR/antigravity.desktop"
MENU_PATH="$HOME/.local/share/applications/antigravity.desktop"

if [ -f "$SHORTCUT_PATH" ]; then
    rm -f "$SHORTCUT_PATH"
    echo "Desktop shortcut removed."
fi

if [ -f "$MENU_PATH" ]; then
    rm -f "$MENU_PATH"
    echo "Application menu shortcut removed."
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "$HOME/.local/share/applications"
    fi
fi

echo "======================================"
echo " Uninstallation Complete!             "
echo "======================================"
