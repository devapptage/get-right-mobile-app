# Get Right - Theme Setup Guide

## ✅ Setup Complete

The Get Right app theme system has been successfully configured with your brand identity!

### 🎨 What's Been Created

#### 1. **Color System** (`lib/theme/color_constants.dart`)
   - Black: `#000000`
   - Green: `#29603C` (Primary brand color)
   - Gray: `#D6D6D6`
   - White: `#F4F4F4`
   - Additional status colors for workout tracking

#### 2. **Typography System** (`lib/theme/text_styles.dart`)
   - **Enra Sans Bold** - Headings and titles
   - **Inter Regular (24pt base)** - Body text
   - Complete hierarchy: headlines, titles, body, labels, buttons
   - Specialized styles for workout stats

#### 3. **Complete Theme** (`lib/theme/app_theme.dart`)
   - Material 3 design system
   - Button styles (Elevated, Outlined, Text)
   - Input fields with clean, modern styling
   - Cards, chips, dialogs, bottom sheets
   - Navigation bar themes
   - System UI overlay configuration

#### 4. **Dependencies Added**
   - `get: ^4.6.6` - State management (GetX)
   - `google_fonts: ^6.2.1` - Inter typography
   - `intl: ^0.19.0` - Date formatting
   - `shared_preferences: ^2.2.3` - Local storage
   - `image_picker: ^1.1.2` - Progress photos
   - `geolocator: ^12.0.0` - GPS run tracking
   - `flutter_map: ^7.0.2` - Map visualization
   - `latlong2: ^0.9.1` - Geo utilities

#### 5. **Project Structure**
```
get_right/
├── lib/
│   ├── theme/
│   │   ├── app_theme.dart           ✅ Complete ThemeData
│   │   ├── color_constants.dart     ✅ Brand colors
│   │   ├── text_styles.dart         ✅ Typography system
│   │   └── README.md                ✅ Documentation
│   └── main.dart                     ✅ Updated with theme
├── assets/
│   ├── fonts/                        📁 For Enra Sans
│   ├── images/                       📁 For app images
│   └── icons/                        📁 For app icons
└── pubspec.yaml                      ✅ Updated dependencies
```

---

## 🚀 Next Steps

### Step 1: Install Dependencies

Run this command in your terminal:

```bash
flutter pub get
```

**If Flutter is not recognized:**
- Ensure Flutter is installed and added to your system PATH
- Or use your IDE's "Pub Get" button (Android Studio/VS Code)

### Step 2: Add Enra Sans Font

1. **Obtain the font files:**
   - Download Enra Sans Bold from your font provider
   - You need at least `EnraSans-Bold.ttf` (or `.otf`)

2. **Add to project:**
   - Place the font file in: `assets/fonts/EnraSans-Bold.ttf`
   - Ensure the filename matches exactly

3. **Verify configuration:**
   - Check `pubspec.yaml` has the correct font path
   - Run `flutter clean` then `flutter pub get`

**📖 See `assets/fonts/README.md` for detailed instructions**

**⚠️ Temporary Fallback:**
Until Enra Sans is added, the app uses **Poppins** (via Google Fonts) for headings. This is similar in style and works out of the box.

### Step 3: Run the App

```bash
flutter run
```

You'll see a **Theme Preview Screen** demonstrating:
- All typography styles
- Color palette
- Button variations
- Input fields
- Cards and chips
- Workout stat display

### Step 4: Replace Preview with Real Screens

The current `main.dart` shows a theme preview. Replace `ThemePreviewScreen` with your actual onboarding or home screen when ready.

---

## 📖 How to Use the Theme

### Using Colors

```dart
import 'package:get_right/theme/color_constants.dart';

Container(
  color: AppColors.green,
  child: Text(
    'Get Right',
    style: TextStyle(color: AppColors.white),
  ),
)
```

### Using Text Styles

```dart
import 'package:get_right/theme/text_styles.dart';

Column(
  children: [
    Text('Welcome Back', style: AppTextStyles.headlineLarge),
    Text('Ready for your workout?', style: AppTextStyles.bodyMedium),
  ],
)
```

### Using Theme in Widgets

```dart
// Buttons automatically use theme styles
ElevatedButton(
  onPressed: () {},
  child: Text('Start Workout'),
)

// Input fields
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
)

// Cards
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Workout Card', style: AppTextStyles.titleMedium),
  ),
)
```

### Accessing Theme in Context

```dart
// Get theme colors
final primaryColor = Theme.of(context).colorScheme.primary;

// Get text styles
final headlineStyle = Theme.of(context).textTheme.headlineLarge;

// Or use directly
Text('Title', style: AppTextStyles.headlineLarge)
```

---

## 🎯 Design Principles Applied

✅ **Clean & Modern**
- Flat UI elements (elevation: 0 on most components)
- Minimal shadows
- Clear visual hierarchy

✅ **Strong Visual Contrast**
- Black text on white backgrounds
- Green accents for CTAs
- Gray for secondary elements

✅ **Ample White Space**
- 24px standard padding
- Proper spacing between elements
- 8-point grid system

✅ **Consistent Typography**
- Bold, athletic headings (Enra Sans)
- Readable body text (Inter, 16-24px)
- Proper line heights (1.5 for body)

✅ **Motivational & Athletic Feel**
- Green accent conveys energy and growth
- Bold typography builds confidence
- Status colors for progress tracking

---

## 🔧 Customization Guide

### Adding New Colors

Edit `lib/theme/color_constants.dart`:

```dart
class AppColors {
  // Add new color
  static const Color accent = Color(0xFFFF5722);
}
```

### Adding New Text Styles

Edit `lib/theme/text_styles.dart`:

```dart
class AppTextStyles {
  static const TextStyle customStyle = TextStyle(
    fontFamily: inter,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.green,
  );
}
```

### Modifying Button Styles

Edit `lib/theme/app_theme.dart`:

```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.black, // Change color
    minimumSize: Size(150, 60),       // Change size
    // ... other modifications
  ),
),
```

---

## 📱 Running the App

### Using Command Line

```bash
# Clean build
flutter clean
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run in release mode (faster)
flutter run --release
```

### Using IDE

**VS Code:**
1. Press `F5` or click "Run > Start Debugging"
2. Select your device from the status bar

**Android Studio:**
1. Click the green play button
2. Select device from dropdown
3. Click "Run"

---

## 🐛 Troubleshooting

### Issue: Flutter command not found
**Solution:** 
- Install Flutter: https://flutter.dev/docs/get-started/install
- Add Flutter to PATH
- Restart terminal/IDE

### Issue: Font not displaying
**Solution:**
- Verify `EnraSans-Bold.ttf` is in `assets/fonts/`
- Check filename matches exactly in `pubspec.yaml`
- Run `flutter clean` then `flutter pub get`
- Restart app (hot reload won't load new fonts)

### Issue: Dependency conflicts
**Solution:**
```bash
flutter clean
flutter pub upgrade
flutter pub get
```

### Issue: Build errors
**Solution:**
- Check `pubspec.yaml` indentation (use spaces, not tabs)
- Ensure all paths are correct
- Run `flutter doctor` to check setup

---

## 📚 Additional Resources

### Theme Documentation
- `lib/theme/README.md` - Complete theme system documentation
- `assets/fonts/README.md` - Font setup instructions

### Flutter Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Material Design 3](https://m3.material.io/)
- [Google Fonts](https://fonts.google.com/)

### Get Right Resources
- Scope of Work - Feature requirements
- Brand Guide - Visual identity

---

## ✨ What's Next?

Now that your theme is set up, you can start building:

1. **Onboarding Flow** - Welcome screens for new users
2. **Authentication** - Signup/Login screens
3. **Home Dashboard** - Main navigation hub
4. **Workout Journal** - Log exercises and progress
5. **Run Tracker** - GPS-based running features
6. **Progress Tracker** - Calendar and stats
7. **Marketplace** - Browse trainer programs

All of these will automatically use your brand theme! 🎉

---

**Need Help?**

If you encounter any issues with the theme setup or need modifications, please check:
1. This guide
2. `lib/theme/README.md`
3. Code comments in theme files

The theme system is fully documented and ready for development! 💪

---

**Get Right** - Your fitness journey starts here!

