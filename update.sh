#!/bin/bash

# Exit on any error
set -e

echo "======================================"
echo " Antigravity Autoupdater (Linux x64)  "
echo "======================================"

# 1. Fetch Latest Link
echo "[1/5] Fetching latest download link..."
PAGE_URL="https://antigravity.google/download"
DOWNLOAD_URL=$(curl -s --compressed "$PAGE_URL" | grep -oP 'https://[^"]*linux-x64/Antigravity\.tar\.gz' | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find the download link on $PAGE_URL."
    exit 1
fi

echo "Found latest version link: $DOWNLOAD_URL"

LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -oP 'antigravity-hub/\K[^/]+')
INSTALLED_VERSION_FILE="/usr/share/antigravity/installed_version.txt"

if [ -f "$INSTALLED_VERSION_FILE" ]; then
    INSTALLED_VERSION=$(cat "$INSTALLED_VERSION_FILE")
    if [ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]; then
        echo "Antigravity is already up to date (version: $INSTALLED_VERSION)."
        echo "Skipping download."
        exit 0
    fi
fi

echo "Updating to version: $LATEST_VERSION"

# 2. Setup Temporary Directory
TEMP_DIR="/tmp/antigravity_update"
echo "[2/5] Setting up temporary directory ($TEMP_DIR)..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# 3. Download & Extract
echo "[3/5] Downloading Antigravity.tar.gz..."
curl -# -O "$DOWNLOAD_URL"

echo "[4/5] Extracting archive..."
tar -xzf Antigravity.tar.gz

if [ ! -d "Antigravity-x64" ]; then
    echo "Error: Extraction failed, 'Antigravity-x64' folder not found."
    exit 1
fi

# 4. Install using Sudo
echo "[5/5] Installing to /usr/share/antigravity..."
echo "You may be prompted for your sudo password to replace the old installation."

sudo rm -rf /usr/share/antigravity
sudo cp -r ./Antigravity-x64 /usr/share/antigravity
echo "$LATEST_VERSION" | sudo tee "$INSTALLED_VERSION_FILE" > /dev/null

# 5. Cleanup
echo "Cleaning up temporary files..."
cd ~
rm -rf "$TEMP_DIR"

echo "======================================"
echo " Update installed successfully!       "
echo "======================================"
