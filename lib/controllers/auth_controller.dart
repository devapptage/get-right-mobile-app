import 'dart:io';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/storage_service.dart';

/// Auth Controller - STATIC/DEMO VERSION (No API Integration)
///
/// This controller handles authentication flow for the ALPHA version.
/// All actions are mocked - no real backend calls are made.
/// Data is stored locally only for demo purposes.
class AuthController extends GetxController {
  final StorageService _storageService;

  AuthController(this._storageService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _tempEmail; // Temporarily store email for OTP flow

  // Note: Removed onInit auto-navigation - Splash screen handles initial routing

  /// Check if onboarding has been completed
  bool isOnboardingComplete() {
    return _storageService.isOnboardingComplete();
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    await _storageService.completeOnboarding();
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _storageService.isLoggedIn();
  }

  /// Login - DEMO VERSION (No API call)
  Future<void> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      update();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Save demo user data locally
      await _storageService.saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
      await _storageService.saveUserId('demo_user_123');
      await _storageService.saveEmail(email);
      await _storageService.saveName('Demo User');
      await _storageService.saveLoginStatus(true);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Signup - DEMO VERSION (No API call)
  Future<void> signup({required String email, required String password, required String firstName, required String lastName}) async {
    try {
      _isLoading = true;
      update();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Save email temporarily for OTP verification
      _tempEmail = email;
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Verify OTP - DEMO VERSION (Accepts any 6-digit code)
  Future<void> verifyOTP(String otp) async {
    try {
      _isLoading = true;
      update();

      if (_tempEmail == null) {
        Get.offAllNamed(AppRoutes.signup);
        return;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Save demo user data locally
      await _storageService.saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
      await _storageService.saveUserId('demo_user_123');
      await _storageService.saveEmail(_tempEmail!);
      await _storageService.saveName('Demo User');
      await _storageService.saveLoginStatus(true);

      _tempEmail = null; // Clear temp email
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Resend OTP - DEMO VERSION
  Future<void> resendOTP() async {
    try {
      _isLoading = true;
      update();

      if (_tempEmail == null) {
        Get.offAllNamed(AppRoutes.signup);
        return;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Forgot password - send reset code - DEMO VERSION
  Future<void> forgotPassword(String email) async {
    try {
      _isLoading = true;
      update();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      _tempEmail = email; // Store email for reset password step
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Reset password - DEMO VERSION
  Future<void> resetPassword({required String otp, required String newPassword}) async {
    try {
      _isLoading = true;
      update();

      if (_tempEmail == null) {
        Get.offAllNamed(AppRoutes.forgotPassword);
        return;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      _tempEmail = null; // Clear temp email
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Change password from settings - DEMO VERSION
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      _isLoading = true;
      update();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storageService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  /// Sign in with Apple - DEMO VERSION
  /// Works for both login and signup (Apple handles both cases)
  Future<void> signInWithApple() async {
    try {
      // Check if Apple Sign-In is available (iOS 13+ or macOS 10.15+)
      if (!Platform.isIOS && !Platform.isMacOS) {
        Get.snackbar('Not Available', 'Apple Sign-In is only available on iOS and macOS devices', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      _isLoading = true;
      update();

      // Check if Apple Sign-In is available
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        _isLoading = false;
        update();
        Get.snackbar('Not Available', 'Apple Sign-In is not available on this device', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Request Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Extract user information
      final email = credential.email ?? credential.userIdentifier;
      final firstName = credential.givenName ?? '';
      final lastName = credential.familyName ?? '';
      final displayName = '${firstName} ${lastName}'.trim();
      final userName = displayName.isNotEmpty ? displayName : 'Apple User';

      // Save demo user data locally
      await _storageService.saveToken('apple_token_${DateTime.now().millisecondsSinceEpoch}');
      await _storageService.saveUserId('apple_user_${credential.userIdentifier}');
      await _storageService.saveEmail(email ?? 'apple_user@example.com');
      await _storageService.saveName(userName);
      await _storageService.saveLoginStatus(true);

      _isLoading = false;
      update();

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } on SignInWithAppleAuthorizationException catch (e) {
      _isLoading = false;
      update();

      // Handle user cancellation
      if (e.code == AuthorizationErrorCode.canceled) {
        // User canceled, do nothing
        return;
      }

      // Handle other errors
      Get.snackbar('Sign-In Failed', e.message.isNotEmpty ? e.message : 'An error occurred during Apple Sign-In', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      _isLoading = false;
      update();
      Get.snackbar('Error', 'Failed to sign in with Apple: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
