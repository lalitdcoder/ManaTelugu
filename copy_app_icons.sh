#!/bin/bash

# Build Phase Script to Copy App Icons
# This script ensures app icons are always included in the app bundle

echo "Copying app icons to app bundle..."

# Get the app bundle path from the build environment
APP_BUNDLE_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"

# Check if the app bundle exists
if [ ! -d "$APP_BUNDLE_PATH" ]; then
    echo "Error: App bundle not found at $APP_BUNDLE_PATH"
    exit 1
fi

# Source icon files
ICON_120_SOURCE="${SRCROOT}/ManaTelugu/AppIcon120.png"
ICON_152_SOURCE="${SRCROOT}/ManaTelugu/AppIcon152.png"

# Check if source files exist
if [ ! -f "$ICON_120_SOURCE" ]; then
    echo "Error: AppIcon120.png not found at $ICON_120_SOURCE"
    exit 1
fi

if [ ! -f "$ICON_152_SOURCE" ]; then
    echo "Error: AppIcon152.png not found at $ICON_152_SOURCE"
    exit 1
fi

# Copy the icon files
echo "Copying AppIcon120.png to app bundle..."
cp "$ICON_120_SOURCE" "$APP_BUNDLE_PATH/AppIcon120.png"

echo "Copying AppIcon152.png to app bundle..."
cp "$ICON_152_SOURCE" "$APP_BUNDLE_PATH/AppIcon152.png"

# Verify the files were copied
if [ -f "$APP_BUNDLE_PATH/AppIcon120.png" ] && [ -f "$APP_BUNDLE_PATH/AppIcon152.png" ]; then
    echo "✅ App icons successfully copied to app bundle!"
    echo "App bundle contents:"
    ls -la "$APP_BUNDLE_PATH" | grep -i icon
else
    echo "❌ Error: Failed to copy app icons"
    exit 1
fi

echo "App icon copy completed successfully!"
