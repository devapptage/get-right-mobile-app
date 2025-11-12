# Google Maps Troubleshooting Guide

## 🔴 Issue: Map Not Working

### Most Common Causes:

1. **Missing API Key** ✅ MOST COMMON
2. **Billing Not Enabled**
3. **APIs Not Enabled**
4. **Wrong Package Name/Bundle ID**
5. **Cache Issues**

---

## ✅ Quick Fix Checklist

### Step 1: Add Your API Key

#### Get Your API Key:
1. Go to https://console.cloud.google.com/
2. Create/Select a project
3. Enable **Maps SDK for Android** and **Maps SDK for iOS**
4. Go to Credentials → Create API Key
5. Copy your key (looks like: `AIzaSyD...`)

#### Add to Android:
File: `android/app/src/main/AndroidManifest.xml` (line 25)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyD_YOUR_ACTUAL_KEY_HERE"/>
```

#### Add to iOS:
File: `ios/Runner/AppDelegate.swift` (line 12)
```swift
GMSServices.provideAPIKey("AIzaSyD_YOUR_ACTUAL_KEY_HERE")
```

---

### Step 2: Enable Billing

**Google Maps requires billing** (but you get $200/month free!)

1. Go to Google Cloud Console
2. Click "Billing" in sidebar
3. Link a payment method
4. You won't be charged unless you exceed free tier

---

### Step 3: Enable Required APIs

In Google Cloud Console:
1. Go to "APIs & Services" → "Library"
2. Search and Enable:
   - ✅ Maps SDK for Android
   - ✅ Maps SDK for iOS

---

### Step 4: Clean Build

```bash
flutter clean
flutter pub get
flutter run
```

---

## 🐛 Specific Error Messages

### Error: "Gray Screen" or "Map doesn't load"
**Cause:** Missing/Invalid API key

**Solution:**
1. Verify API key is correct (no extra spaces)
2. Wait 5-10 minutes after creating new key
3. Check billing is enabled
4. Verify APIs are enabled

---

### Error: "API key not valid"
**Cause:** Restrictions on API key

**Solution:**
1. Remove restrictions temporarily to test
2. If it works, add restrictions properly:

**For Android:**
- Go to API key settings
- Under "Application restrictions" → Android apps
- Add package name: `com.getright.app`
- Add SHA-1 fingerprint:
  ```bash
  # Get debug key fingerprint
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

**For iOS:**
- Under "Application restrictions" → iOS apps
- Add bundle ID: `com.getright.app`

---

### Error: "MissingPluginException"
**Cause:** google_maps_flutter not installed

**Solution:**
```bash
flutter pub get
flutter clean
flutter run
```

---

### Error: "PlatformException"
**Cause:** Location permissions not granted

**Solution:**
1. Check permissions are in AndroidManifest.xml
2. Uninstall app and reinstall
3. Grant location permission when prompted

---

## 📱 Platform-Specific Issues

### Android Issues

#### Map shows "For development purposes only"
**Cause:** API key needs SHA-1 fingerprint restriction

**Solution:**
1. Get SHA-1 fingerprint (see above)
2. Add to API key restrictions
3. Rebuild app

#### Error in logcat: "Authorization failure"
**Solution:**
1. Check package name matches in:
   - `android/app/build.gradle` → `applicationId`
   - Google Cloud Console → API restrictions
2. Verify SHA-1 is correct
3. Wait 5-10 minutes after adding restrictions

---

### iOS Issues

#### Map not showing on iOS
**Solution:**
1. Verify API key in AppDelegate.swift
2. Check bundle ID matches
3. Run pod install:
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

#### Error: "GMSServices must be called"
**Cause:** API key not initialized in AppDelegate

**Solution:**
Verify this code is in `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_KEY_HERE")
```

---

## 🧪 Testing Your Setup

### Test 1: Check API Key is Set
Look in files:
- `android/app/src/main/AndroidManifest.xml` (line 25)
- `ios/Runner/AppDelegate.swift` (line 12)

Should NOT say: `YOUR_GOOGLE_MAPS_API_KEY_HERE`

### Test 2: Check Permissions
**Android:** `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

**iOS:** `ios/Runner/Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location...</string>
```

### Test 3: Verify Package Installation
Run:
```bash
flutter pub get
flutter doctor -v
```

Look for google_maps_flutter in output.

### Test 4: Check Google Cloud Console
1. Go to https://console.cloud.google.com/
2. Check "APIs & Services" → "Dashboard"
3. Verify Maps SDK shows as "Enabled"
4. Check "Billing" shows payment method

---

## 🔧 Advanced Troubleshooting

### Reset Everything
```bash
# Clear Flutter cache
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Reinstall dependencies
flutter pub get

# Android specific
cd android
./gradlew clean
cd ..

# iOS specific (Mac only)
cd ios
pod deintegrate
pod install
cd ..

# Rebuild
flutter run
```

### Check Logcat (Android)
```bash
flutter run
# In another terminal:
adb logcat | grep -i "google\|maps\|location"
```

Look for errors mentioning:
- "Authorization failure"
- "API key"
- "MapsInitializer"

### Check Console (iOS)
In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Run app
3. View console for errors

---

## 💰 Cost Information

### Free Tier
- $200 credit per month
- Dynamic Maps: First 100,000 loads free
- After free tier: $0.007 per load

### For Get Right App
**Estimated usage:**
- Personal use: 50-100 map loads/month
- Cost: $0.00 (well within free tier)

**When you'll be charged:**
- If you exceed $200/month usage
- Unlikely for personal fitness app

---

## 📚 Additional Resources

- Google Maps Platform Documentation: https://developers.google.com/maps/documentation
- Flutter Google Maps Plugin: https://pub.dev/packages/google_maps_flutter
- Google Cloud Console: https://console.cloud.google.com/

---

## ✅ Success Checklist

Before running app, confirm:
- ✅ API key added to both Android & iOS
- ✅ Billing enabled in Google Cloud
- ✅ Maps SDK enabled for both platforms
- ✅ Location permissions in manifest files
- ✅ `flutter pub get` ran successfully
- ✅ Waited 5-10 minutes after API key creation

---

## 🆘 Still Not Working?

1. Check `GET_GOOGLE_MAPS_API_KEY.md` for detailed setup
2. Try the test app at bottom to isolate issue
3. Check Google Cloud Console → "APIs & Services" → "Credentials" for any errors
4. Contact support with specific error messages

---

**Remember:** 99% of Google Maps issues are solved by:
1. Adding a valid API key
2. Enabling billing
3. Waiting a few minutes
4. Running `flutter clean && flutter pub get`

