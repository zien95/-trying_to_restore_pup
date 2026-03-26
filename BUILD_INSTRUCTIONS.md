# iOS IPA Build Scripts for Sideloadly

This repository contains scripts to build IPA files for sideloading your Flutter pet game onto iOS devices using Sideloadly.

## 🍎 Prerequisites

1. **macOS** - Required for iOS builds
2. **Flutter SDK** - Installed and in PATH
3. **Xcode** - Installed from App Store
4. **Sideloadly** - Download from [sideloadly.io](https://sideloadly.io/)

## 📱 Build Scripts

### Quick Build (Recommended for Sideloadly)
```bash
./build_sideloadly.sh
```

**Features:**
- Fast build without code signing
- Optimized for Sideloadly
- No Apple Developer account required
- Creates IPA ready for sideloading

### Full Build (Advanced)
```bash
./build_ipa.sh [release|debug] [team_id]
```

**Features:**
- Full build with optional code signing
- More verbose output
- Error checking and validation
- Optional Apple Developer Team ID

## 🚀 How to Use

### 1. Build the IPA
```bash
# Navigate to your project directory
cd /path/to/trying_to_restore_pup

# Run the quick build script
./build_sideloadly.sh
```

### 2. Sideload with Sideloadly
1. Open Sideloadly on your Mac
2. Connect your iPhone/iPad via USB
3. Drag the generated IPA file to Sideloadly
4. Enter your Apple ID and password
5. Click "Start" to install

### 3. Find Your IPA
The IPA file will be created at:
```
build/ios/Sideloadly_trying_to_restore_pup.ipa
```

## ⚠️ Important Notes

- **Free Apple ID Required**: You need a free Apple ID for sideloading
- **7-Day Expiry**: Sideloaded apps expire after 7 days and must be reinstalled
- **Trust Certificate**: After installing, go to Settings > General > VPN & Device Management and trust the developer certificate
- **iOS Compatibility**: Works on iOS 12.0 and above

## 🔧 Troubleshooting

### Build Issues
```bash
# Clean everything and retry
flutter clean
rm -rf ios/Pods
rm ios/Podfile.lock
./build_sideloadly.sh
```

### Sideloadly Issues
- Update to latest Sideloadly version
- Restart your iPhone/iPad
- Try a different USB cable
- Check iOS compatibility (iOS 12.0+)

### Common Errors
- **"Flutter not found"**: Install Flutter SDK and add to PATH
- **"Xcode not found"**: Install Xcode from App Store
- **"Build failed"**: Run `flutter doctor` and fix issues

## 📱 Device Support

Sideloadly supports:
- iPhone (all models)
- iPad (all models) 
- iPod Touch (supported models)

## 🔄 Automatic Re-signing

The app will need to be reinstalled every 7 days. Simply run the build script again and sideload the new IPA.

## 🎮 Game Features

Your Flutter pet game includes:
- 🐕 Multiple pet types (Dog, Cat, Bunny, Bird, Dragon)
- 🎵 Sound effects with haptic feedback
- 📊 Stats management (Hunger, Energy, Cleanliness, Happiness, Health)
- 🎖️ Level system with XP
- 💾 Persistent save data
- 🎨 Beautiful UI with Material Design

Enjoy your pet game on iOS! 🎉
