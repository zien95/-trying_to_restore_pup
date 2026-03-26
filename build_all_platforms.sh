#!/bin/bash

# Comprehensive Build Script for Pet Care Game
# Builds for macOS, Android (APK), and iOS (IPA)

set -e  # Exit on any error

echo "🎮 Pet Care Game - Multi-Platform Build Script"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
    exit 1
fi

# Create build directories
mkdir -p build_outputs
mkdir -p build_outputs/macos
mkdir -p build_outputs/android
mkdir -p build_outputs/ios
mkdir -p build_outputs/macos/Build/Products/Release

print_status "Starting multi-platform build process..."

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
rm -rf build/
rm -rf build_outputs/

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Check Flutter installation
print_status "Checking Flutter installation..."
flutter doctor -v

echo ""
echo "=============================================="
echo "🍎 BUILDING FOR macOS"
echo "=============================================="

# Build for macOS
print_status "Building macOS app..."
flutter build macos --release --no-tree-shake-icons

if [ $? -eq 0 ]; then
    # Copy macOS build to output directory
    cp -r build/macos/Build/Products/Release/pup.app build_outputs/macos/
    
    # Create DMG for easier distribution
    print_status "Creating macOS DMG..."
    hdiutil create -volname "Pet Care Game" -srcfolder build_outputs/macos/pup.app -ov -format UDZO build_outputs/PetCareGame-macos.dmg
    
    print_success "✅ macOS build completed successfully!"
    print_status "macOS app location: build_outputs/macos/pup.app"
    print_status "macOS DMG location: build_outputs/PetCareGame-macos.dmg"
else
    print_error "❌ macOS build failed!"
fi

echo ""
echo "=============================================="
echo "🤖 BUILDING FOR Android"
echo "=============================================="

# Build for Android
print_status "Building Android APK..."
flutter build apk --release --split-per-abi --no-tree-shake-icons

if [ $? -eq 0 ]; then
    # Copy Android builds to output directory
    cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk build_outputs/android/PetCareGame-arm64.apk
    cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk build_outputs/android/PetCareGame-arm32.apk
    cp build/app/outputs/flutter-apk/app-x86_64-release.apk build_outputs/android/PetCareGame-x64.apk
    
    # Also build universal APK
    print_status "Building universal Android APK..."
    flutter build apk --release --no-tree-shake-icons
    cp build/app/outputs/flutter-apk/app-release.apk build_outputs/android/PetCareGame-universal.apk
    
    # Build AAB for Play Store
    print_status "Building Android App Bundle (AAB)..."
    flutter build appbundle --release --no-tree-shake-icons
    cp build/app/outputs/bundle/release/app-release.aab build_outputs/android/PetCareGame-playstore.aab
    
    print_success "✅ Android build completed successfully!"
    print_status "Android APKs location: build_outputs/android/"
    print_status "Play Store AAB location: build_outputs/android/PetCareGame-playstore.aab"
else
    print_error "❌ Android build failed!"
fi

echo ""
echo "=============================================="
echo "📱 BUILDING FOR iOS"
echo "=============================================="

# Build for iOS
print_status "Building iOS app (unsigned)..."
flutter build ios --release --no-codesign --no-tree-shake-icons

if [ $? -eq 0 ]; then
    # Create IPA with proper payload structure
    print_status "Creating iOS IPA package..."
    
    # Create IPA directory structure
    mkdir -p build_outputs/ios/Payload
    
    # Copy the app bundle
    cp -r build/ios/iphoneos/Runner.app build_outputs/ios/Payload/
    
    # Create IPA
    cd build_outputs/ios
    zip -r PetCareGame-ios.ipa Payload/
    cd ../..
    
    print_success "✅ iOS build completed successfully!"
    print_status "iOS IPA location: build_outputs/ios/PetCareGame-ios.ipa"
    print_warning "Note: This IPA is unsigned and requires sideloading tools like AltStore"
else
    print_error "❌ iOS build failed!"
fi

echo ""
echo "=============================================="
echo "📊 BUILD SUMMARY"
echo "=============================================="

# Generate build info
BUILD_DATE=$(date '+%Y-%m-%d %H:%M:%S')
FLUTTER_VERSION=$(flutter --version | head -n 1)

cat > build_outputs/BUILD_INFO.txt << EOF
Pet Care Game - Build Information
================================
Build Date: $BUILD_DATE
Flutter Version: $FLUTTER_VERSION
Build Type: Release

Files Generated:
- macOS: PetCareGame-macos.dmg
- Android (ARM64): PetCareGame-arm64.apk
- Android (ARM32): PetCareGame-arm32.apk
- Android (x64): PetCareGame-x64.apk
- Android (Universal): PetCareGame-universal.apk
- Android (Play Store): PetCareGame-playstore.aab
- iOS: PetCareGame-ios.ipa

Installation Instructions:
- macOS: Open the DMG file and drag pup.app to Applications
- Android: Install the appropriate APK for your device architecture
- iOS: Use sideloading tools like AltStore (unsigned IPA)
EOF

print_success "Build information saved to: build_outputs/BUILD_INFO.txt"

# Display file sizes
echo ""
print_status "Generated file sizes:"
if [ -d "build_outputs" ]; then
    ls -lh build_outputs/*.* 2>/dev/null || true
    ls -lh build_outputs/android/*.* 2>/dev/null || true
fi

echo ""
print_success "🎉 Multi-platform build completed!"
print_status "All builds are available in the 'build_outputs' directory"

# Create installation guide
cat > build_outputs/INSTALLATION_GUIDE.md << EOF
# Pet Care Game - Installation Guide

## 🍎 macOS Installation
1. Open `PetCareGame-macos.dmg`
2. Drag `pup.app` to your Applications folder
3. Launch from Applications or Launchpad

## 🤖 Android Installation

### For Most Devices:
1. Install `PetCareGame-universal.apk`
2. Enable "Install from unknown sources" in settings
3. Tap the APK file to install

### For Specific Architecture:
- **ARM64 (newer devices)**: `PetCareGame-arm64.apk`
- **ARM32 (older devices)**: `PetCareGame-arm32.apk`
- **x64 (emulators/tablets)**: `PetCareGame-x64.apk`

### Google Play Store:
- Use `PetCareGame-playstore.aab` for Play Store submission

## 📱 iOS Installation

### Using AltStore (Recommended):
1. Install AltStore on your iOS device
2. Open `PetCareGame-ios.ipa` in AltStore
3. Follow the on-screen instructions to sideload

### Using Other Sideloaders:
- The IPA is unsigned and compatible with most sideloading tools
- You may need to trust the developer certificate after installation

## 🔧 Troubleshooting

### macOS:
- If you get "unidentified developer" error: Right-click app → Open → Trust
- Ensure you have macOS 10.14 or later

### Android:
- Enable "Unknown Sources" in Security settings
- Clear cache if installation fails
- Try the universal APK if architecture-specific fails

### iOS:
- Ensure your Apple ID has 2FA enabled
- Free Apple IDs can only install 3 apps at a time
- Consider AltStore for easiest sideloading

## 📱 Features Available
- Account system with profiles
- 10+ mini-games including Memory Match, Word Puzzle, Rhythm Game
- Daily challenges and rewards
- Premium features and upgrades
- Real-time notifications
- Message system
- Achievement tracking

Enjoy playing Pet Care Game! 🐾
EOF

print_success "Installation guide created: build_outputs/INSTALLATION_GUIDE.md"

echo ""
print_status "🎮 Ready to distribute Pet Care Game on all platforms!"
