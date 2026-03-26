#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# 🔧 Flutter M4 Mac Fix Script
# ═══════════════════════════════════════════════════════════════
# Fixes the "darwin-x64-release/FlutterMacOS.xcframework" error
# ═══════════════════════════════════════════════════════════════

echo "🚀 Starting Flutter M4 Mac Fix..."
echo ""

# Step 1: Clean everything
echo "🧹 Step 1/5: Cleaning Flutter cache..."
flutter clean
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf macos/Pods
rm -rf macos/.symlinks
rm -rf macos/Podfile.lock

# Step 2: Clean Flutter cache artifacts
echo "🗑️  Step 2/5: Removing old Flutter artifacts..."
rm -rf ~/flutter/bin/cache/artifacts/engine/darwin-x64*
rm -rf ~/flutter/bin/cache/artifacts/engine/darwin-x64-release
rm -rf ~/flutter/bin/cache/artifacts/engine/darwin-x64-profile
rm -rf ~/flutter/bin/cache/artifacts/engine/darwin-x64-debug

# Step 3: Precache macOS artifacts (ARM64)
echo "📦 Step 3/5: Downloading ARM64 artifacts..."
flutter precache --macos --no-ios --no-android --no-web --no-linux --no-windows

# Step 4: Get dependencies
echo "📱 Step 4/5: Getting Flutter dependencies..."
flutter pub get

# Step 5: Run pod install with ARM64 architecture
echo "💎 Step 5/5: Installing CocoaPods (ARM64)..."
cd macos
arch -arm64 pod install
cd ..

echo ""
echo "✅ Fix completed!"
echo "🎉 Now try running: flutter run -d macos"
