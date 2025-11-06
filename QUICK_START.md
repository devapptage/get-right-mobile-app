# Get Right - Quick Start Guide

## ✅ Font Error Fixed!

The asset error for `EnraSans-Bold.ttf` has been resolved. The app now uses **Inter** font (via Google Fonts) as a fallback and will build successfully.

---

## 🚀 Run the App (3 Steps)

### 1. Install Dependencies
Open terminal in the project root and run:
```bash
flutter pub get
```

### 2. Run the App
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For Web
flutter run -d chrome

# For Windows
flutter run -d windows
```

### 3. Test the App
- **Splash Screen** → Auto-navigates to onboarding
- **Onboarding** → 4 pages, swipe or tap Next
- **Login/Signup** → Create account or login
- **Home Screen** → Access all features via bottom navigation

---

## 📱 Features

| Screen | Status | Description |
|--------|--------|-------------|
| **Auth** | ✅ Ready | Login, Signup, OTP verification, Forgot password |
| **Home** | ✅ Ready | Dashboard with quick stats and bottom navigation |
| **Journal** | ✅ Ready | Log workouts (sets, reps, weight, notes) |
| **Planner** | ✅ Ready | Create workout plans and schedules |
| **Tracker** | ✅ Ready | GPS-based run tracking (requires location permission) |
| **Marketplace** | ✅ Ready | Browse trainer programs and courses |
| **Profile** | ✅ Ready | View and edit user profile |
| **Settings** | ✅ Ready | App settings and preferences |

---

## 🎨 Theme

- **Colors:** Green (#29603C), Black (#000000), Gray (#D6D6D6), White (#F4F4F4)
- **Typography:** Inter font (via Google Fonts) for all text
- **Design:** Clean, modern, minimal style with proper spacing

---

## ⚠️ Known Limitations (Alpha Version)

1. **API Integration:** Using mock responses (no backend required)
2. **EnraSans Font:** Not included (using Inter as fallback) - see `FONT_FIX_AND_SETUP.md`
3. **GPS Tracking:** Requires location permissions on device
4. **Image Upload:** Not fully implemented
5. **Chat/Messaging:** UI only (no real-time functionality)

---

## 🔧 If Flutter Command Not Found

**Windows:**
1. Download Flutter SDK from https://flutter.dev
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to system PATH
4. Restart terminal
5. Run `flutter doctor` to verify

**macOS/Linux:**
```bash
# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

---

## 📚 Documentation

- `FONT_FIX_AND_SETUP.md` - Font configuration and setup
- `THEME_SETUP_GUIDE.md` - Complete theme customization guide
- `IMPLEMENTATION_COMPLETE.md` - Full project documentation
- `assets/fonts/README.md` - Font files setup
- `lib/theme/README.md` - Theme system overview

---

## 🛠️ Troubleshooting

**Issue: "Unable to locate asset entry"**
- ✅ Fixed! The font configuration has been updated.
- If issue persists, run: `flutter clean` then `flutter pub get`

**Issue: "flutter command not found"**
- Ensure Flutter is installed and added to system PATH
- Run `flutter doctor` to diagnose

**Issue: "No connected devices"**
- For Android: Enable USB debugging on device
- For iOS: Open Xcode and accept licenses
- For Web: Use `-d chrome` flag
- For Windows: Use `-d windows` flag

**Issue: "Waiting for another flutter command to release the startup lock"**
- Delete `bin/cache/lockfile` in Flutter SDK directory
- Or restart your computer

---

## 📝 Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter run`
3. ⚠️ Test all screens and navigation
4. ⚠️ (Optional) Add EnraSans font for exact brand match
5. ⚠️ Connect to real backend API (when ready)
6. ⚠️ Test on physical devices

---

## 📞 Support

For issues or questions:
- Check the documentation files in the project root
- Review Flutter documentation at https://docs.flutter.dev
- Run `flutter doctor` to diagnose issues

---

**Happy Coding! 🎉**

