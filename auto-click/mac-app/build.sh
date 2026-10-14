#!/bin/bash
# Construit AutoClick.app à partir de AutoClick.swift
set -e
cd "$(dirname "$0")"

APP="AutoClick.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

swiftc -parse-as-library -O -o "$APP/Contents/MacOS/AutoClick" AutoClick.swift

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>AutoClick</string>
    <key>CFBundleDisplayName</key><string>AutoClick</string>
    <key>CFBundleExecutable</key><string>AutoClick</string>
    <key>CFBundleIdentifier</key><string>com.maxime.autoclick</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
    <key>NSPrincipalClass</key><string>NSApplication</string>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

# Signature locale : permet à macOS de retenir l'autorisation Accessibilité
codesign --force --deep --sign - "$APP"

echo "OK : $APP créée"
