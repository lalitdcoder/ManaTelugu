#!/bin/bash

# Script to fix app icon validation issues
# This script copies the required icon files to the app bundle

echo "Fixing app icon validation issues..."

# Find the app bundle
APP_BUNDLE_PATH=""
if [ -d "./ManaTelugu.xcarchive/Products/Applications/ManaTelugu.app" ]; then
    APP_BUNDLE_PATH="./ManaTelugu.xcarchive/Products/Applications/ManaTelugu.app"
elif [ -d "/Users/pavan/Library/Developer/Xcode/DerivedData/ManaTelugu-dywsgrcffkznrjgyqnjcemuiaisq/Build/Products/Debug-iphoneos/ManaTelugu.app" ]; then
    APP_BUNDLE_PATH="/Users/pavan/Library/Developer/Xcode/DerivedData/ManaTelugu-dywsgrcffkznrjgyqnjcemuiaisq/Build/Products/Debug-iphoneos/ManaTelugu.app"
elif [ -d "/Users/pavan/Library/Developer/Xcode/DerivedData/ManaTelugu-dywsgrcffkznrjgyqnjcemuiaisq/Build/Products/Release-iphoneos/ManaTelugu.app" ]; then
    APP_BUNDLE_PATH="/Users/pavan/Library/Developer/Xcode/DerivedData/ManaTelugu-dywsgrcffkznrjgyqnjcemuiaisq/Build/Products/Release-iphoneos/ManaTelugu.app"
fi

if [ -z "$APP_BUNDLE_PATH" ]; then
    echo "Error: Could not find app bundle"
    exit 1
fi

echo "Found app bundle at: $APP_BUNDLE_PATH"

# Copy the icon files
cp "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/AppIcon120.png" "$APP_BUNDLE_PATH/AppIcon120.png"
cp "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/AppIcon152.png" "$APP_BUNDLE_PATH/AppIcon152.png"

echo "Icon files copied successfully!"
echo "App bundle contents:"
ls -la "$APP_BUNDLE_PATH" | grep -i icon

echo "Done!"
