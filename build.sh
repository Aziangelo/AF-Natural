#!/bin/bash

LD_LIBRARY_PATH=./tool/lib python3 tool $@

# Define source and destination
SRC="build/android/"
DEST="/storage/emulated/0/games/com.mojang/resource_packs/AziFyNATUR/renderer/materials/"

# Copy files source to destination (overwrite existing files)
cp -r "$SRC"* "$DEST"

echo "Files copied successfully!"