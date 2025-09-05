#!/bin/bash

# Script to copy app icons to the app bundle
# This script should be run as a build phase

APP_BUNDLE_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"

# Copy the icon files to the app bundle
cp "${SRCROOT}/ManaTelugu/AppIcon120.png" "${APP_BUNDLE_PATH}/AppIcon120.png"
cp "${SRCROOT}/ManaTelugu/AppIcon152.png" "${APP_BUNDLE_PATH}/AppIcon152.png"

echo "App icons copied to ${APP_BUNDLE_PATH}"
