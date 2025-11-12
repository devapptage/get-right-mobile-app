# Google Maps Setup Guide

## Overview
The Run Tracker has been updated to use **Google Maps** instead of OpenStreetMap for better performance, customization, and native feel.

## What Changed
1. **Removed packages:**
   - `flutter_map: ^7.0.2`
   - `latlong2: ^0.9.1`

2. **Added package:**
   - `google_maps_flutter: ^2.6.1`

3. **Updated screens:**
   - `run_tracker_screen.dart` - Map preview with Google Maps
   - `active_run_screen.dart` - Live tracking with Google Maps
   - `run_summary_screen.dart` - Route visualization with Google Maps

## Setup Instructions

### 1. Install Dependencies
Run the following command to install Google Maps Flutter:

```bash
flutter pub get
```

### 2. Get Google Maps API Keys

#### For Android:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **Maps SDK for Android**
4. Go to **Credentials** → **Create Credentials** → **API Key**
5. Copy the API key

#### For iOS:
1. In the same Google Cloud Console project
2. Enable **Maps SDK for iOS**
3. Use the same API key or create a new one

### 3. Configure Android

Edit `android/app/src/main/AndroidManifest.xml`:

Add the following **inside** the `<application>` tag:

```xml
<application
    ...>
    
    <!-- Add this meta-data for Google Maps API Key -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_ANDROID_API_KEY_HERE"/>
    
    <!-- Rest of your application config -->
    ...
</application>
```

### 4. Configure iOS

Edit `ios/Runner/AppDelegate.swift`:

Add the import at the top:

```swift
import GoogleMaps
```

Then, inside the `application` function, add:

```swift
override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

### 5. Update iOS Podfile (if needed)

Edit `ios/Podfile` and ensure the platform version is at least 14.0:

```ruby
platform :ios, '14.0'
```

Then run:

```bash
cd ios
pod install
cd ..
```

### 6. Test the Implementation

Run your app:

```bash
flutter run
```

Navigate to the Run Tracker screen and verify:
- Map loads correctly
- Your location marker appears
- GPS Ready badge shows
- Dark theme is applied to the map

## Features Implemented

### 1. Run Tracker Screen
- **Google Maps Preview** with custom dark styling
- **Current location marker** with green pin
- **GPS accuracy circle** showing positioning accuracy
- **GPS Ready badge** when location is acquired
- **Smooth animations** on marker appearance
- **Custom map style** matching app's dark theme

### 2. Active Run Screen
- **Live route tracking** with polyline
- **Real-time position updates** every 2 seconds
- **Camera auto-follow** to keep user centered
- **Custom dark map styling**
- **Dotted polyline** for the running route

### 3. Run Summary Screen
- **Complete route visualization**
- **Start marker** (green) and **End marker** (red)
- **Solid polyline** showing completed route
- **Zoom controls** enabled for detailed view
- **Compass** for orientation

## Custom Map Styling

All screens use a custom dark theme that matches your app's black/gray/green color scheme:

- **Background:** Dark gray (#1a1a1a)
- **Roads:** Medium gray (#2a2a2a)
- **Parks:** Dark green (#29603C with -40 lightness)
- **Water:** Black (#000000)
- **Labels:** Light gray (#8a8a8a)

## Troubleshooting

### Map not showing:
1. Verify API key is correctly added
2. Check that Maps SDK is enabled in Google Cloud Console
3. Ensure billing is enabled on your Google Cloud project
4. Check internet connection

### iOS build errors:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Android build errors:
```bash
flutter clean
flutter pub get
flutter run
```

## API Key Security

**Important:** Never commit API keys to version control!

For production:
1. Use environment variables
2. Restrict API keys by package name (Android) and bundle ID (iOS)
3. Set up API key restrictions in Google Cloud Console
4. Consider using Firebase Remote Config for dynamic key management

## Cost Considerations

Google Maps has usage-based pricing:
- **$0.007 per map load** for Android/iOS
- **First $200/month is free** (Google Cloud credits)
- Each map initialization counts as one load

For this app's use case (run tracking), costs should be minimal for personal use.

## Next Steps

1. Add your API keys to the configuration files
2. Run `flutter pub get`
3. Test on both Android and iOS devices
4. Customize map markers if needed
5. Add additional map layers (traffic, terrain, etc.)

---

**Status:** ✅ Google Maps integration complete
**Date:** November 11, 2025

