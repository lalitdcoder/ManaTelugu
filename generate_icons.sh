#!/bin/bash

# This script generates all the required app icon sizes from a source 1024x1024 image.

SOURCE_ICON="ManaTelugu/1024.png"
ICONSET_PATH="ManaTelugu/ManaTelugu/Assets.xcassets/AppIcon.appiconset"

if [ ! -f "$SOURCE_ICON" ]; then
    echo "Error: Source icon not found at $SOURCE_ICON"
    exit 1
fi

echo "Generating icons..."

# iPhone icons
sips -z 40 40 "$SOURCE_ICON" --out "$ICONSET_PATH/40.png"
sips -z 60 60 "$SOURCE_ICON" --out "$ICONSET_PATH/60.png"
sips -z 58 58 "$SOURCE_ICON" --out "$ICONSET_PATH/58.png"
sips -z 87 87 "$SOURCE_ICON" --out "$ICONSET_PATH/87.png"
sips -z 80 80 "$SOURCE_ICON" --out "$ICONSET_PATH/80.png"
sips -z 120 120 "$SOURCE_ICON" --out "$ICONSET_PATH/120.png"
sips -z 120 120 "$SOURCE_ICON" --out "$ICONSET_PATH/120x120.png"
sips -z 180 180 "$SOURCE_ICON" --out "$ICONSET_PATH/180.png"

# iPad icons
sips -z 20 20 "$SOURCE_ICON" --out "$ICONSET_PATH/20.png"
sips -z 40 40 "$SOURCE_ICON" --out "$ICONSET_PATH/40-ipad.png"
sips -z 29 29 "$SOURCE_ICON" --out "$ICONSET_PATH/29.png"
sips -z 58 58 "$SOURCE_ICON" --out "$ICONSET_PATH/58-ipad.png"
sips -z 40 40 "$SOURCE_ICON" --out "$ICONSET_PATH/40-ipad-2.png"
sips -z 80 80 "$SOURCE_ICON" --out "$ICONSET_PATH/80-ipad.png"
sips -z 76 76 "$SOURCE_ICON" --out "$ICONSET_PATH/76.png"
sips -z 152 152 "$SOURCE_ICON" --out "$ICONSET_PATH/152x152.png"
sips -z 167 167 "$SOURCE_ICON" --out "$ICONSET_PATH/167.png"

echo "Done generating icons."
