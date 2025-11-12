# How to Get Google Maps API Key

## Quick Steps

### 1. Go to Google Cloud Console
Visit: https://console.cloud.google.com/

### 2. Create or Select a Project
- Click on the project dropdown at the top
- Click "New Project" or select existing project
- Name it (e.g., "Get Right App")

### 3. Enable Required APIs
Go to "APIs & Services" → "Library"

Enable these APIs:
- ✅ **Maps SDK for Android**
- ✅ **Maps SDK for iOS**

### 4. Create API Key
1. Go to "APIs & Services" → "Credentials"
2. Click "+ CREATE CREDENTIALS"
3. Select "API Key"
4. Copy your API key (it will look like: `AIzaSyD...`)

### 5. Restrict Your API Key (Important for Security)

#### For Android:
1. Click on your API key name
2. Under "Application restrictions" → Select "Android apps"
3. Click "Add an item"
4. Package name: `com.getright.app` (or your app's package name)
5. Get SHA-1 certificate fingerprint:
   ```bash
   # For debug builds
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Add the SHA-1 fingerprint

#### For iOS:
1. Under "Application restrictions" → Select "iOS apps"
2. Add bundle identifier: `com.getright.app` (or your app's bundle ID)

### 6. Add API Key to Your App

#### Android (`android/app/src/main/AndroidManifest.xml`)
Replace line 25:
```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

#### iOS (`ios/Runner/AppDelegate.swift`)
Replace line 12:
```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
```

### 7. Enable Billing (Required)
Google Maps requires billing to be enabled, but you get:
- **$200 free credit per month**
- Most personal apps stay under this limit

Go to "Billing" in Google Cloud Console and add a payment method.

---

## Alternative: Use a .env File (Recommended for Security)

Don't commit your API key to Git! Use environment variables instead.

### 1. Create `.env` file in project root:
```
GOOGLE_MAPS_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

### 2. Add `.env` to `.gitignore`:
```
.env
```

### 3. Add package to `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

### 4. Load in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
```

### 5. Use in code:
```dart
String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
```

---

## Troubleshooting

### Map shows gray screen?
- ✅ Check API key is correct
- ✅ Verify billing is enabled
- ✅ Confirm APIs are enabled (Maps SDK for Android/iOS)
- ✅ Check SHA-1 fingerprint matches (Android)
- ✅ Verify bundle ID matches (iOS)

### "API key not valid" error?
- Wait 5-10 minutes after creating the key
- Clear app data and reinstall
- Check API key restrictions

### Still not working?
```bash
flutter clean
flutter pub get
flutter run
```

---

**Important:** Never commit your actual API key to public repositories!

