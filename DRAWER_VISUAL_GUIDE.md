# Get Right App Drawer - Visual Guide

## Drawer Layout

```
╔════════════════════════════════════╗
║  [User Profile Header]             ║
║  ┌────────┐                        ║
║  │   GR   │  Demo User             ║
║  └────────┘  demo@getright.com     ║
║              [View Profile]        ║
╠════════════════════════════════════╣
║  MAIN                              ║
║  🏠  Dashboard                     ║
║  👤  Profile                       ║
║  ⚙️  Settings                      ║
║                                    ║
║  ────────────────────────────────  ║
║                                    ║
║  FITNESS                           ║
║  📖  Journal                       ║
║  📅  Planner                       ║
║  🏃  Run Tracker                   ║
║  📈  Progress                      ║
║                                    ║
║  ────────────────────────────────  ║
║                                    ║
║  COMMUNITY                         ║
║  🏬  Marketplace                   ║
║  💬  Messages                      ║
║  👥  Trainers                      ║
║                                    ║
║  ────────────────────────────────  ║
║                                    ║
║  HELP & SUPPORT                    ║
║  ❓  Help & Feedback               ║
║  ℹ️  About                         ║
║  🔒  Privacy Policy                ║
║                                    ║
╠════════════════════════════════════╣
║  [🚪 Logout]                       ║
╚════════════════════════════════════╝
```

## Color Scheme

### User Profile Header
- **Background**: Dark Gray (`#1A1A1A`)
- **Avatar Circle**: Green (`#29603C`) with Gray border
- **Name Text**: White (`#F4F4F4`)
- **Email Text**: Gray (`#D6D6D6`)
- **View Profile Button**: Green border with green text

### Navigation Body
- **Background**: Black (`#000000`)
- **Section Labels**: Gray uppercase text
- **Navigation Items**: 
  - Icon: Gray (`#D6D6D6`)
  - Text: White (`#F4F4F4`)
  - Hover: Light green tint
- **Dividers**: Thin gray lines

### Logout Section
- **Background**: Black with top border
- **Button**: Red border (`#B00020`)
- **Text & Icon**: Red (`#B00020`)

## Interaction States

### Default State
```
║  📖  Journal  ←─── Gray icon, White text
```

### Hover State
```
║  📖  Journal  ←─── Light green background
```

### Selected State
```
║  📖  Journal  ←─── Green-tinted background
```

## Opening Animation

1. **Tap menu icon** → Drawer slides in from left
2. **Smooth animation** → 300ms ease-out
3. **Backdrop** → Semi-transparent overlay on main content

## User Interactions

### Opening the Drawer
```
┌─────────────────┐
│ ☰  Get Right   │  ← Tap hamburger menu
└─────────────────┘
        ↓
    [Drawer slides in]
```

### Navigation Flow
```
Drawer Open → Select Item → Drawer Closes → Navigate to Screen
```

### Logout Flow
```
Tap Logout Button
    ↓
[Dialog Appears]
╔══════════════════════╗
║     Logout          ║
║                     ║
║ Are you sure you    ║
║ want to logout?     ║
║                     ║
║  [Cancel] [Logout]  ║
╚══════════════════════╝
    ↓ Confirm
  Logout → Login Screen
```

## Responsive Behavior

### Phone (Portrait)
- **Drawer Width**: 280px
- **Overlap**: Full screen overlay

### Tablet (Landscape)
- **Drawer Width**: 320px
- **Side Panel**: Can be persistent

## Accessibility Features

1. **High Contrast**: White text on black background
2. **Clear Labels**: All items clearly labeled
3. **Touch Targets**: Minimum 48px height
4. **Semantic Structure**: Proper heading hierarchy

## Technical Implementation

### Opening Drawer Programmatically
```dart
// From anywhere in the app with BuildContext
Scaffold.of(context).openDrawer();
```

### Closing Drawer
```dart
// After navigation
Get.back(); // Closes drawer
```

### Navigation Pattern
```dart
onTap: () {
  Get.back(); // Close drawer first
  Get.toNamed(AppRoutes.profile); // Then navigate
}
```

## Best Practices Implemented

✓ **Consistent Theming** - Matches app design perfectly  
✓ **Clear Organization** - Logical section grouping  
✓ **Visual Feedback** - Hover and selection states  
✓ **Safety Measures** - Logout confirmation dialog  
✓ **User Context** - Profile info always visible  
✓ **Performance** - Smooth animations, no lag  
✓ **Accessibility** - Proper contrast and sizing  

## Screen Integration

### Home/Dashboard Screen
```dart
Scaffold(
  drawer: const AppDrawer(), // ← Drawer added here
  appBar: AppBar(
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
  ),
)
```

### Other Screens
- Detail screens use back button (no drawer needed)
- Settings, profile, etc. accessible from drawer
- Consistent navigation pattern throughout app

## Testing Scenarios

1. ✓ Open drawer from menu button
2. ✓ Navigate to each section
3. ✓ Verify user info displays
4. ✓ Test logout with cancel
5. ✓ Test logout with confirm
6. ✓ Check drawer closes after navigation
7. ✓ Verify theme consistency
8. ✓ Test on different screen sizes

---

**Status**: ✅ Implementation Complete  
**Version**: 1.0.0 Alpha  
**Last Updated**: November 2025

