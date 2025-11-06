# Get Right - Alpha Version Guide (Static Screens Only)

## 🎯 Overview

This is the **Alpha Version** of the Get Right app - a fully functional Flutter application with **NO backend integration**. All screens are static with demo/mock data for UI testing and user feedback.

---

## ✅ What's Included (100% Static)

### 1. **Authentication Flow**
All auth screens are fully functional with mock success responses:

| Screen | What Works | Notes |
|--------|------------|-------|
| **Splash** | Auto-navigation based on state | ✅ No API |
| **Onboarding** | 4-page intro with animations | ✅ Static content |
| **Login** | Form validation, mock success | ✅ Any email/password works |
| **Signup** | Form validation, navigates to OTP | ✅ Data stored locally |
| **OTP** | Accepts any 6-digit code | ✅ Auto-navigates to home |
| **Forgot Password** | Reset flow with mock OTP | ✅ Any email works |

**Demo Flow:**
1. Open app → Splash (2s)
2. Complete onboarding (4 pages)
3. Sign up with any email (e.g., `test@example.com`)
4. Enter any 6-digit OTP (e.g., `123456`)
5. ✅ You're in!

---

### 2. **Main App Navigation**
Bottom navigation with 5 main tabs:

#### 📖 **Journal Tab**
- Empty state with "Add Workout" button
- Navigates to Add Workout screen (form with validation)
- **Note:** Data not persisted (alpha version)

```dart
Screens:
- journal_screen.dart → Empty state
- add_workout_screen.dart → Workout entry form
```

#### 📅 **Planner Tab**
- Empty state with "Create Plan" button
- Shows workout planning interface
- **Note:** Static UI only

```dart
Screens:
- planner_screen.dart → Empty state with FAB
```

#### 📊 **Tracker Tab**
- 2 tabs: Calendar & Runs
- Coming soon placeholders for both
- **Note:** GPS not implemented yet

```dart
Screens:
- tracker_screen.dart → Tabs with placeholders
```

#### 🏪 **Programs Tab** (Marketplace)
- Empty state for browsing trainer programs
- Search & filter icons (UI only)
- **Note:** No programs loaded

```dart
Screens:
- marketplace_screen.dart → Empty state
```

#### 👤 **Profile Tab**
- Displays user name/email from local storage
- Stats cards (static demo data)
- Edit profile, settings, logout buttons
- **Note:** Profile edits not saved

```dart
Screens:
- profile_screen.dart → User profile with local data
- edit_profile_screen.dart → Profile edit form
- settings_screen.dart → Settings options
```

---

## 🔧 Technical Implementation

### No Backend Required

**What We're Using:**
- ✅ **Local Storage Only** (`shared_preferences`)
- ✅ **Mock Controllers** (simulate loading states)
- ✅ **Static UI Components**
- ✅ **Form Validation** (no submission)

**What We're NOT Using:**
- ❌ API calls
- ❌ HTTP requests
- ❌ Real authentication
- ❌ Database
- ❌ Real data persistence

### Controller Structure

**`AuthController` (Simplified for Alpha):**
```dart
/// Auth Controller - STATIC/DEMO VERSION (No API Integration)
class AuthController extends GetxController {
  final StorageService _storageService; // Local storage only
  
  // No API service needed!
  
  /// Login - Accepts any credentials
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    await _storageService.saveLoginStatus(true); // Save locally
    Get.offAllNamed(AppRoutes.home); // Navigate
  }
  
  /// Signup → OTP → Home (all mocked)
  /// Logout → Clears local data
}
```

**Key Points:**
- ✅ No `ApiService` dependency
- ✅ Only uses `StorageService` for local data
- ✅ All methods return mock success
- ✅ Navigation works perfectly
- ✅ Loading states are simulated

---

## 📱 Features by Screen

### Authentication Screens (`lib/views/auth/`)

#### **splash_screen.dart**
- Shows app logo and loading spinner
- Initializes `StorageService` only
- Auto-navigates based on:
  - First time → Onboarding
  - Onboarded + logged in → Home
  - Onboarded + not logged in → Login

#### **onboarding_screen.dart**
- 4 pages with illustrations
- Page indicators
- Skip button
- Next/Get Started button
- Saves completion status locally

#### **login_screen.dart**
- Email & password fields with validation
- "Forgot Password" link
- Social login placeholder (Google)
- Sign up link
- **Demo:** Any email/password works!

#### **signup_screen.dart**
- First/Last name fields
- Email & password validation
- Confirm password matching
- Terms & Conditions checkbox
- Navigates to OTP screen

#### **otp_screen.dart**
- 6-digit OTP input
- Countdown timer (60s)
- Resend OTP button
- **Demo:** Any 6 digits work (e.g., `123456`)

#### **forgot_password_screen.dart**
- Email input → OTP → New password
- Two-step form
- **Demo:** Any email and OTP work

---

### Main App Screens (`lib/views/`)

#### **home_screen.dart**
- Bottom navigation controller
- Manages 5 tabs (Journal, Planner, Tracker, Programs, Profile)
- Uses `IndexedStack` for state preservation

#### **journal/journal_screen.dart**
- Empty state by default
- FAB to add workout
- Search & filter icons (UI only)

#### **journal/add_workout_screen.dart**
- Exercise name input
- Sets, reps, weight fields
- Tags selection
- Notes field
- **Note:** Form validates but doesn't save

#### **planner/planner_screen.dart**
- Empty state with "Create Plan" CTA
- FAB for adding plans
- Templates icon (UI only)

#### **tracker/tracker_screen.dart**
- TabBar with Calendar & Runs
- Both show "Coming Soon" placeholders

#### **marketplace/marketplace_screen.dart**
- Empty state with browse message
- Search & filter icons (UI only)

#### **profile/profile_screen.dart**
- User info from local storage
- Stats cards (static demo numbers)
- Action cards:
  - Edit Profile
  - Settings
  - Help & Support
  - Logout (works!)

#### **profile/edit_profile_screen.dart**
- Name, email, phone fields
- Gender, weight, height inputs
- **Note:** Changes not saved (alpha)

#### **settings/settings_screen.dart**
- Notifications toggle
- Theme selection (UI only)
- Account settings
- Privacy policy links

---

## 🎨 Theme System

### Colors (Brand)
```dart
Green:  #29603C (Primary)
Black:  #000000 (Text/Backgrounds)
Gray:   #D6D6D6 (Borders/Dividers)
White:  #F4F4F4 (Backgrounds/Text)
```

### Typography
```dart
Headings: Inter Bold (fallback from EnraSans)
Body:     Inter Regular
Sizes:    32, 28, 24, 22, 18, 16, 14, 12, 11
```

### Components
All custom widgets in `lib/widgets/`:
- `custom_button.dart` - Primary & outline buttons
- `custom_text_field.dart` - Text inputs with validation
- `loading_indicator.dart` - Loading states
- `empty_state.dart` - Empty list placeholders
- `workout_card.dart` - Workout display cards
- `program_card.dart` - Marketplace program cards

---

## 🚀 Running the Alpha Version

### 1. Install Dependencies
```bash
cd d:/getright/get_right
flutter pub get
```

### 2. Run the App
```bash
# Choose your platform:
flutter run                    # Auto-detect
flutter run -d chrome          # Web
flutter run -d windows         # Windows
```

### 3. Test the Flow
1. **Splash** → Wait 2 seconds
2. **Onboarding** → Swipe through 4 pages or Skip
3. **Signup** → Enter any email (e.g., `demo@getright.com`)
4. **OTP** → Enter `123456`
5. **Home** → Explore all 5 tabs
6. **Profile** → Try logout (clears local data)

---

## 📊 What Data is Saved?

### Local Storage Only (No Backend)
Using `SharedPreferences`:
- ✅ Onboarding completion status
- ✅ Login status (true/false)
- ✅ User email
- ✅ User name
- ✅ Auth token (fake/demo)

**On Logout:**
- All local data is cleared
- User returns to login screen

**On App Restart:**
- If logged in → Goes to Home
- If not logged in → Goes to Login
- If first time → Goes to Onboarding

---

## ⚠️ Known Limitations (Alpha)

### Not Implemented:
1. ❌ Real API integration
2. ❌ Data persistence (workouts, plans)
3. ❌ GPS run tracking (UI only)
4. ❌ Image uploads
5. ❌ Program purchases
6. ❌ Chat/messaging
7. ❌ Calendar integration
8. ❌ Social features
9. ❌ Push notifications
10. ❌ Payment processing

### Working:
1. ✅ All UI screens
2. ✅ Navigation flow
3. ✅ Form validation
4. ✅ Local authentication state
5. ✅ Bottom navigation
6. ✅ Theme system
7. ✅ Responsive layouts
8. ✅ Loading states
9. ✅ Snackbar messages
10. ✅ Dialog/modal popups

---

## 🎯 Alpha Version Purpose

### What This is For:
- ✅ UI/UX testing with users
- ✅ Design validation
- ✅ Navigation flow feedback
- ✅ Stakeholder demonstrations
- ✅ Investor pitches
- ✅ User research studies
- ✅ A/B testing designs

### What This is NOT For:
- ❌ Production use
- ❌ Real user workouts
- ❌ Data collection
- ❌ App store release
- ❌ Payment processing

---

## 🔮 Future: Adding Backend

When backend is ready, you'll only need to update:

### 1. **ApiService** (`lib/services/api_service.dart`)
```dart
// Replace mock responses with real HTTP calls
Future<Map<String, dynamic>> login({...}) async {
  final response = await http.post(...); // Real API call
  return jsonDecode(response.body);
}
```

### 2. **Controllers** (if needed)
```dart
// Update controllers to use ApiService
class AuthController extends GetxController {
  final ApiService _apiService; // Add back API dependency
  // ...
}
```

### 3. **Splash Screen**
```dart
// Re-add ApiService initialization
final api = await ApiService.getInstance();
Get.put(AuthController(storage, api));
```

**Everything else stays the same!**

---

## 📚 File Structure

```
lib/
├── main.dart                    → App entry point
├── controllers/
│   └── auth_controller.dart     → Auth logic (no API)
├── views/
│   ├── auth/                    → Login, signup, OTP, etc.
│   ├── home/                    → Main app shell
│   ├── journal/                 → Workout logging
│   ├── planner/                 → Workout planning
│   ├── tracker/                 → Progress tracking
│   ├── marketplace/             → Programs
│   ├── profile/                 → User profile
│   └── settings/                → App settings
├── widgets/
│   ├── common/                  → Buttons, inputs, etc.
│   └── cards/                   → Workout & program cards
├── models/                      → Data models (unused for now)
├── services/
│   └── storage_service.dart     → Local storage only
├── utils/
│   ├── helpers.dart             → Snackbars, dialogs, formatting
│   └── validators.dart          → Form validation
├── routes/
│   ├── app_routes.dart          → Route names
│   └── app_pages.dart           → Route configuration
├── theme/
│   ├── app_theme.dart           → App theme
│   ├── color_constants.dart     → Brand colors
│   └── text_styles.dart         → Typography
└── constants/
    ├── app_constants.dart       → App-wide constants
    └── asset_paths.dart         → Asset paths
```

---

## 🐛 Troubleshooting

### Issue: "flutter command not found"
**Fix:** Add Flutter to system PATH and restart terminal

### Issue: "No connected devices"
**Fix:** Use `-d chrome` or `-d windows` flag

### Issue: "Can't verify OTP"
**Solution:** Any 6 digits work! Try `123456`

### Issue: "Login not working"
**Solution:** Any email/password works! No real validation.

### Issue: "Workouts not saving"
**Expected:** Alpha version doesn't save workouts (static UI only)

### Issue: "Profile changes not saved"
**Expected:** Alpha version doesn't persist profile changes

---

## ✨ Summary

### Alpha Version Status: ✅ COMPLETE

- ✅ All screens implemented
- ✅ Navigation works end-to-end
- ✅ Forms validate properly
- ✅ No backend required
- ✅ Ready for user testing
- ✅ Ready for stakeholder demos
- ✅ Clean, modern UI with brand colors

### Next Steps (Future):
1. User testing and feedback collection
2. Backend API development
3. Integrate real authentication
4. Implement data persistence
5. Add GPS run tracking
6. Implement marketplace transactions
7. Beta version release

---

**🎉 Your alpha version is ready to demo!**

Run `flutter pub get` and `flutter run` to see it in action.

