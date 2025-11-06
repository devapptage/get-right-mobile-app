# Get Right Theme System

This directory contains the complete theming system for the Get Right Flutter application.

## Files Overview

### `color_constants.dart`
Defines all brand colors as constant values:
- **Brand Colors**: Black (#000000), Green (#29603C), Gray (#D6D6D6), White (#F4F4F4)
- **Status Colors**: Completed, Upcoming, Missed (for workout tracking)
- **Semantic Colors**: Primary, Secondary, Background, Surface, Error
- **Neutral Shades**: Light, Medium, and Dark gray variants

**Usage:**
```dart
import 'package:get_right/theme/color_constants.dart';

Container(
  color: AppColors.green,
  child: Text('Get Right', style: TextStyle(color: AppColors.white)),
)
```

### `text_styles.dart`
Defines all typography styles using:
- **Enra Sans (Bold)** - for headings, titles, and buttons
- **Inter (Regular, 24pt base)** - for body text and UI elements

**Typography Hierarchy:**
- `headlineLarge` → 32px, Bold (Enra Sans)
- `headlineMedium` → 28px, Bold (Enra Sans)
- `titleLarge` → 22px, Bold (Enra Sans)
- `bodyLarge` → 24px, Regular (Inter)
- `bodyMedium` → 16px, Regular (Inter)
- `labelSmall` → 11px, Medium (Inter)

**Usage:**
```dart
import 'package:get_right/theme/text_styles.dart';

Text('Welcome', style: AppTextStyles.headlineLarge);
Text('Your fitness journey', style: AppTextStyles.bodyMedium);
```

### `app_theme.dart`
Complete `ThemeData` configuration including:
- Color scheme
- Text theme
- Button styles (Elevated, Outlined, Text)
- Input decoration
- Card theme
- App bar theme
- Bottom navigation
- Dialog, Chip, Switch, Checkbox themes
- System UI overlay styles

**Usage in main.dart:**
```dart
import 'package:get_right/theme/app_theme.dart';

GetMaterialApp(
  theme: AppTheme.lightTheme,
  home: HomeScreen(),
)
```

## Design Principles

The Get Right theme follows these principles:

1. **Clean & Minimal**
   - Flat UI elements (no heavy shadows)
   - Ample white space
   - Clear visual hierarchy

2. **Strong Contrast**
   - Black text on white backgrounds
   - Green accents for CTAs and highlights
   - Gray for secondary elements

3. **Consistent Spacing**
   - 8-point grid system
   - Standardized padding and margins
   - Proper touch targets (min 44px)

4. **Typography Hierarchy**
   - Bold headings (Enra Sans)
   - Readable body text (Inter, 16-24px)
   - Sufficient line height (1.5 for body)

5. **Athletic & Motivational**
   - Energy through green accent
   - Bold, confident typography
   - Dynamic micro-interactions

## Customization

### Adding New Colors
Add to `color_constants.dart`:
```dart
static const Color newColor = Color(0xFF123456);
```

### Adding New Text Styles
Add to `text_styles.dart`:
```dart
static const TextStyle customStyle = TextStyle(
  fontFamily: inter,
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: AppColors.black,
);
```

### Modifying Theme
Update `app_theme.dart`:
```dart
static ThemeData get lightTheme {
  return ThemeData(
    // Your modifications
  );
}
```

## Font Setup

**Inter** is automatically loaded via `google_fonts` package.

**Enra Sans** requires manual setup:
1. Add font files to `assets/fonts/`
2. Ensure `pubspec.yaml` font configuration is correct
3. Run `flutter pub get`

See `assets/fonts/README.md` for detailed instructions.

## Testing Theme

Run the app to see the **Theme Preview Screen** which demonstrates:
- All typography styles
- Color palette
- Button variations
- Input fields
- Cards and chips
- Stats display

This preview screen can be found in `lib/main.dart` and should be replaced with your actual onboarding or home screen.

## Integration Example

```dart
import 'package:flutter/material.dart';
import 'package:get_right/theme/app_theme.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Journal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Workout', style: AppTextStyles.headlineLarge),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Leg Day', style: AppTextStyles.titleMedium),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Text('Start Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Notes

- All theme files follow Flutter best practices
- Fully compatible with GetX state management
- Material 3 design system
- Scalable for future customization
- Ready for dark mode implementation (future enhancement)

---

**Get Right** - Your fitness journey starts here! 💪

