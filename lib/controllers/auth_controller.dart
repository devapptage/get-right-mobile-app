import 'package:get/get.dart';
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

      Get.toNamed(AppRoutes.otp);
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
}
