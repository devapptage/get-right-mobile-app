import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/Local%20Storage/local_storage.dart';
import 'package:get_right/controllers/auth%20controller/user_controller.dart';
import 'package:get_right/controllers/notification_controller.dart';
import 'package:get_right/repo/auth_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth controller/base_controller.dart';

class AuthController extends BaseController {
  // --- Text controllers ---
  late final NotificationController notificationController;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController otpController = TextEditingController(); // unused in current OTP UI but kept
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final RxString _selectedType = 'other'.obs;
  // Individual OTP field controllers for better management
  late final List<TextEditingController> otpControllers;
  late final List<FocusNode> otpFocusNodes;

  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final LocalStorage localStorage = Get.put<LocalStorage>(LocalStorage());

  void clearLoading() {
    isLoading.value = false;
  }

  // --- Reactive state ---

  final RxInt signupStep = 1.obs; // 1 = basic info, 2 = OTP, 3 = profile
  final RxInt profileSetupStep = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;
  final RxBool isOtpVerified = false.obs;
  final RxString selectedGender = ''.obs;
  final RxBool isPrivateProfile = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool hasRecordedBio = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<File?> coverImage = Rx<File?>(null);
  final RxString audioUri = ''.obs;
  RxBool isLoginLoading = false.obs;
  RxBool isProfileLoading = false.obs;
  RxBool isSignupLoading = false.obs;
  RxBool isForgotPasswordLoading = false.obs;
  RxBool isResetPasswordLoading = false.obs;
  RxBool googleLoginLoading = false.obs;
  RxBool appleLoginLoading = false.obs;
  // Validation errors - separate for login and signup
  final RxMap<String, String?> loginErrors = <String, String?>{}.obs;
  final RxMap<String, String?> signupErrors = <String, String?>{}.obs;

  // Legacy errors map for backward compatibility
  final RxMap<String, String?> errors = <String, String?>{}.obs;

  // Backend
  final repo = AuthRepository();
  String userId = "";
  String token = "";

  // DOB
  final Rx<DateTime> selectedDate = DateTime.now().subtract(const Duration(days: 4745)).obs; // ~13y
  final RxBool showDatePicker = false.obs;

  // OTP digits for 6 boxes
  final RxList<String> otp = List<String>.filled(6, '').obs;

  // Remember Me functionality
  final RxBool rememberMe = false.obs;
  final RxBool showRememberMeModal = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize notification controller
    notificationController = Get.put(NotificationController());

    // Initialize OTP controllers and focus nodes
    otpControllers = List.generate(6, (index) => TextEditingController());
    otpFocusNodes = List.generate(6, (index) => FocusNode());

    // Load remember me preference and saved credentials
    // _loadRememberMeSettings();
  }

  final ImagePicker _imagePicker = ImagePicker();
  UserController userController = Get.put(UserController());

  final RxBool isEmailVerified = false.obs;
  final RxBool isProfileComplete = false.obs;

  bool _parseEmailVerified(Map<String, dynamic>? user) {
    if (user == null) return false;
    return user['isVerified'] == true;
  }

  bool _parseProfileComplete(Map<String, dynamic>? user) {
    if (user == null) return false;
    return user['isProfileCompleted'] == true;
  }

  void _prefillProfileFieldsFromServer(Map<String, dynamic>? user) {
    if (user == null) return;
    dobController.text = (user['dateOfBirth'] ?? '').toString();
    selectedGender.value = (user['gender'] ?? '').toString();
    isPrivateProfile.value = user['profileVisibility']?.toString().toLowerCase() == 'private';
    audioUri.value = (user['bioVoice'] ?? '').toString();

    // Remote images (URLs) ko yahan File me mat daalo. UI widget me URL handle karo.
    profileImage.value = null;
    coverImage.value = null;
  }

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dobController.dispose();
    otpController.dispose();
    bioController.dispose();
    usernameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();

    // Dispose OTP controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }

    super.onClose();
  }

  //  login

  // Future<void> login() async {
  //   // Clear previous errors
  //   loginErrors.clear();
  //   errors.clear();

  //   // Client-side validation
  //   bool hasValidationError = false;

  //   if (loginEmailController.text.trim().isEmpty) {
  //     loginErrors['email'] = 'Email is required';
  //     errors['email'] = 'Email is required';
  //     hasValidationError = true;
  //   } else if (!_isValidEmail(loginEmailController.text.trim())) {
  //     loginErrors['email'] = 'Please enter a valid email address';
  //     errors['email'] = 'Please enter a valid email address';
  //     hasValidationError = true;
  //   }

  //   if (loginPasswordController.text.isEmpty) {
  //     loginErrors['password'] = 'Password is required';
  //     errors['password'] = 'Password is required';
  //     hasValidationError = true;
  //   } else if (loginPasswordController.text.length < 8) {
  //     loginErrors['password'] = 'Please enter a valid password (minimum 8 characters)';
  //     errors['password'] = 'Please enter a valid password (minimum 8 characters)';
  //     hasValidationError = true;
  //   }

  //   if (hasValidationError) {
  //     return;
  //   }

  //   try {
  //     isLoginLoading.value = true;

  //     // Get FCM device token for notifications
  //     String deviceToken = notificationController.fcmToken.value;
  //     if (deviceToken.isEmpty) {
  //       deviceToken = await notificationController.getFcmToken() ?? "";
  //       print('Retrieved FCM token for login: $deviceToken');
  //     }

  //     final result = await repo.loginRepo(
  //       email: loginEmailController.text.trim(),
  //       password: loginPasswordController.text,
  //       deviceType: Platform.isAndroid ? "Android" : "IOS",
  //       deviceToken: deviceToken,
  //     );
  //     clearLoading();

  //     if (result["status"] == 200 && result["data"] != null) {
  //       // Check if the response contains the new account status fields
  //       final hasAccountStatusFields = result["data"].containsKey("exists") || result["data"].containsKey("isDeleted") || result["data"].containsKey("isDeletedByAdmin");

  //       if (hasAccountStatusFields) {
  //         // Handle new response format with account status fields
  //         final userExists = result["data"]["exists"] ?? false;
  //         final isDeleted = result["data"]["isDeleted"] ?? false;
  //         final isDeletedByAdmin = result["data"]["isDeletedByAdmin"] ?? false;
  //         final responseMessage = result["message"]?.toString() ?? "";

  //         if (!userExists) {
  //           // User doesn't exist
  //           isLoginLoading.value = false;
  //           _handleUserNotFoundError(responseMessage);
  //         } else if (isDeletedByAdmin) {
  //           // Account deleted by admin
  //           isLoginLoading.value = false;
  //           _handleAccountDeletedByAdminError(responseMessage);
  //         } else if (isDeleted) {
  //           // Account deleted by user
  //           isLoginLoading.value = false;
  //           _handleAccountDeletedByUserError(responseMessage);
  //         } else {
  //           // Successful login - user exists and is not deleted
  //           _handleSuccessfulLogin(result);
  //         }
  //       } else {
  //         // Handle traditional successful login response (no account status fields)
  //         _handleSuccessfulLogin(result);
  //       }
  //     } else if (result["status"] == 410) {
  //       // Handle 410 Gone - Account has been deleted
  //       isLoginLoading.value = false;
  //       _handleLoginError("This account has been deleted");
  //     } else {
  //       // Handle API error response
  //       final errorMessage = result["message"]?.toString() ?? "Login failed";
  //       _handleLoginError(errorMessage);
  //       isLoginLoading.value = false;
  //     }
  //   } catch (e) {
  //     isLoginLoading.value = false;
  //     clearLoading();
  //     _handleLoginError(e.toString());
  //   }
  // }

  // // social login

  // googleLogin() {
  //   try {
  //     googleLoginLoading.value = true;
  //     SocialAuthService()
  //         .signInWithGoogle()
  //         .then((result) async {
  //           if (result != null) {
  //             log(result.toString());
  //             Map<String, String> reqBody = {
  //               'access_token': idToken,
  //               'device_token': notificationController.fcmToken.value.toString(),
  //               'provider': signInMethod,
  //               'platform': Platform.operatingSystem,
  //             };
  //             var socialLoginResult = await repo.socialLogin(reqBody);

  //             // log(reqBody.toString());
  //             if (socialLoginResult["status"] == 200 && socialLoginResult["data"] != null) {
  //               // Check if the response contains the new account status fields
  //               final hasAccountStatusFields =
  //                   socialLoginResult["data"].containsKey("exists") ||
  //                   socialLoginResult["data"].containsKey("isDeleted") ||
  //                   socialLoginResult["data"].containsKey("isDeletedByAdmin");

  //               if (hasAccountStatusFields) {
  //                 // Handle new response format with account status fields
  //                 final userExists = socialLoginResult["data"]["exists"] ?? false;
  //                 final isDeleted = socialLoginResult["data"]["isDeleted"] ?? false;
  //                 final isDeletedByAdmin = socialLoginResult["data"]["isDeletedByAdmin"] ?? false;
  //                 final responseMessage = socialLoginResult["message"]?.toString() ?? "";

  //                 if (!userExists) {
  //                   // User doesn't exist
  //                   googleLoginLoading.value = false;
  //                   _handleUserNotFoundError(responseMessage);
  //                 } else if (isDeletedByAdmin) {
  //                   // Account deleted by admin
  //                   googleLoginLoading.value = false;
  //                   _handleAccountDeletedByAdminError(responseMessage);
  //                 } else if (isDeleted) {
  //                   // Account deleted by user
  //                   googleLoginLoading.value = false;
  //                   _handleAccountDeletedByUserError(responseMessage);
  //                 } else {
  //                   // Successful login - user exists and is not deleted
  //                   _handleSuccessfulSocialLogin(socialLoginResult);
  //                 }
  //               } else {
  //                 // Handle traditional successful login response (no account status fields)
  //                 _handleSuccessfulSocialLogin(socialLoginResult);
  //               }
  //             }

  //             googleLoginLoading.value = false;
  //           } else {
  //             googleLoginLoading.value = false;
  //           }
  //         })
  //         .onError((error, stackTrace) {
  //           googleLoginLoading.value = false;

  //           debugPrint(error.toString());
  //           debugPrint(stackTrace.toString());
  //         });
  //   } catch (error) {
  //     googleLoginLoading.value = false;

  //     debugPrint(error.toString());
  //     throw error.toString();
  //   }
  // }

  // appleLogin() {
  //   try {
  //     appleLoginLoading.value = true;
  //     SocialAuthService()
  //         .signInWithApple()
  //         .then((user) async {
  //           if (user != null) {
  //             log(user.toString());
  //             Map<String, String> reqBody = {
  //               'access_token': idToken,
  //               'device_token': notificationController.fcmToken.value.toString(),
  //               'provider': signInMethod,
  //               'platform': Platform.operatingSystem,
  //             };
  //             log(reqBody.toString());

  //           }
  //           appleLoginLoading.value = false;
  //         })
  //         .onError((error, stackTrace) {
  //           appleLoginLoading.value = false;
  //           debugPrint(error.toString());
  //           debugPrint(stackTrace.toString());
  //         });
  //   } catch (error) {
  //     appleLoginLoading.value = false;
  //     debugPrint(error.toString());
  //     throw error.toString();
  //   }
  // }

  // // social login

  // void _routeAfterLogin({required bool emailVerified, required bool profileComplete, Map<String, dynamic>? user}) {
  //   isEmailVerified.value = emailVerified;
  //   isProfileComplete.value = profileComplete;

  //   if (!emailVerified) {
  //     emailController.text = loginEmailController.text.trim();
  //     isOtpSent.value = true;
  //     signupStep.value = 2;
  //     Get.to(() => const SignupScreen());
  //     return;
  //   }
  //   if (emailVerified && !profileComplete) {
  //     emailController.text = loginEmailController.text.trim();
  //     isOtpSent.value = true;
  //     signupStep.value = 3;
  //     Get.to(() => const SignupScreen());
  //     return;
  //   }

  //   if (!profileComplete) {
  //     signupStep.value = 3;
  //     profileSetupStep.value = 1;
  //     _prefillProfileFieldsFromServer(user);
  //     Get.to(() => ProfileSetupScreen());
  //     return;
  //   }

  //   Get.offAll(() => const MainNavigationScreen());
  // }

  // /// Handle login-specific errors with proper validation messages
  // void _handleLoginError(String errorMessage) {
  //   if (errorMessage.toLowerCase().contains('deleted') ||
  //       errorMessage.toLowerCase().contains('account has been deleted') ||
  //       errorMessage.toLowerCase().contains('user has been deleted') ||
  //       errorMessage.toLowerCase().contains('account deleted')) {
  //     // Handle deleted account
  //     Get.dialog(
  //       AlertDialog(
  //         backgroundColor: AppColors.neutralBlack,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           side: BorderSide(color: AppColors.errorPrimary.withOpacity(0.3), width: 1),
  //         ),
  //         title: Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(color: AppColors.errorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
  //               child: Icon(Icons.error_outline, color: AppColors.errorPrimary, size: 24),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Text(
  //                 'Account Deleted',
  //                 style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.neutralWhite),
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Text(
  //           'This account has been deleted and is no longer accessible. If you believe this is an error, please contact support.',
  //           style: GoogleFonts.merriweather(fontSize: 16, color: AppColors.neutralWhite.withOpacity(0.8), height: 1.5),
  //         ),
  //         actions: [
  //           Container(
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: TextButton(
  //               onPressed: () => Get.back(),
  //               child: Text(
  //                 'OK',
  //                 style: GoogleFonts.merriweather(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       barrierDismissible: false,
  //     );
  //   } else if (errorMessage.toLowerCase().contains('invalid credentials') || errorMessage.toLowerCase().contains('wrong password')) {
  //     loginErrors['password'] = 'Invalid email or password';
  //     errors['password'] = 'Invalid email or password';
  //     Get.snackbar(
  //       "Login Failed",
  //       "Invalid email or password. Please check your credentials.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 3),
  //     );
  //   } else if (errorMessage.toLowerCase().contains('user not found') || errorMessage.toLowerCase().contains('email not found')) {
  //     loginErrors['email'] = 'Email not found. Please check your email address.';
  //     errors['email'] = 'User not found. Please check your email address.';
  //     Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //   } else if (errorMessage.toLowerCase().contains('account not verified') || errorMessage.toLowerCase().contains('email not verified')) {
  //     loginErrors['email'] = 'Please verify your email address first.';
  //     errors['email'] = 'Please verify your email address first.';
  //     Get.snackbar(
  //       "Account Not Verified",
  //       "Please verify your email address before logging in.",
  //       backgroundColor: Colors.orange,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 4),
  //     );
  //   } else if (errorMessage.toLowerCase().contains('too many attempts') || errorMessage.toLowerCase().contains('rate limit')) {
  //     Get.snackbar(
  //       "Too Many Attempts",
  //       "Too many login attempts. Please wait before trying again.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 4),
  //     );
  //   } else if (errorMessage.toLowerCase().contains('list') || errorMessage.toLowerCase().contains('dynamics')) {
  //     // Handle server-side validation errors that might be returned as "List dynamics..."
  //     loginErrors['password'] = 'Please enter a valid password (minimum 8 characters)';
  //     errors['password'] = 'Please enter a valid password (minimum 8 characters)';
  //     Get.snackbar("Login Failed", "Please enter a valid password (minimum 8 characters)", backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //   } else {
  //     // Generic error handling
  //     Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //   }
  // }

  // /// Handle user not found error with custom dialog
  // void _handleUserNotFoundError(String message) {
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: AppColors.neutralBlack,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: BorderSide(color: AppColors.errorPrimary.withOpacity(0.3), width: 1),
  //       ),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(color: AppColors.errorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
  //             child: Icon(Icons.person_off_outlined, color: AppColors.errorPrimary, size: 24),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               'Account Not Found',
  //               style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.neutralWhite),
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         message.isNotEmpty ? message : 'No account found with this email address. Please check your email or create a new account.',
  //         style: GoogleFonts.merriweather(fontSize: 16, color: AppColors.neutralWhite.withOpacity(0.8), height: 1.5),
  //       ),
  //       actions: [
  //         Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: () => Get.back(),
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.merriweather(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // /// Handle account deleted by admin error with custom dialog
  // void _handleAccountDeletedByAdminError(String message) {
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: AppColors.neutralBlack,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: BorderSide(color: AppColors.errorPrimary.withOpacity(0.3), width: 1),
  //       ),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(color: AppColors.errorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
  //             child: Icon(Icons.admin_panel_settings_outlined, color: AppColors.errorPrimary, size: 24),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               'Account Suspended',
  //               style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.neutralWhite),
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         message.isNotEmpty ? message : 'This account has been suspended by an administrator. If you believe this is an error, please contact support.',
  //         style: GoogleFonts.merriweather(fontSize: 16, color: AppColors.neutralWhite.withOpacity(0.8), height: 1.5),
  //       ),
  //       actions: [
  //         Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: () => Get.back(),
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.merriweather(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // /// Handle account deleted by user error with custom dialog
  // void _handleAccountDeletedByUserError(String message) {
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: AppColors.neutralBlack,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: BorderSide(color: AppColors.errorPrimary.withOpacity(0.3), width: 1),
  //       ),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(color: AppColors.errorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
  //             child: Icon(Icons.delete_outline, color: AppColors.errorPrimary, size: 24),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               'Account Deleted',
  //               style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.neutralWhite),
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         message.isNotEmpty ? message : 'This account has been deleted and is no longer accessible. If you want to use our service again, please create a new account.',
  //         style: GoogleFonts.merriweather(fontSize: 16, color: AppColors.neutralWhite.withOpacity(0.8), height: 1.5),
  //       ),
  //       actions: [
  //         Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: () => Get.back(),
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.merriweather(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: AppColors.accentBlue.withOpacity(0.5), width: 1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: () {
  //               Get.back();
  //               _showSupportTicketDialog();
  //             },
  //             child: Text(
  //               'Support',
  //               style: GoogleFonts.merriweather(color: AppColors.accentBlue, fontSize: 16, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // /// Handle successful login - common logic for both traditional and new response formats
  // void _handleSuccessfulLogin(Map<String, dynamic> result) {
  //   token = result["data"]["token"].toString();
  //   localStorage.saveAccessToken(token);

  //   userId = result["data"]["user"]["_id"]?.toString() ?? "";
  //   final emailVerified = _parseEmailVerified(result["data"]["user"]);
  //   final profileComplete = _parseProfileComplete(result["data"]["user"]);

  //   // Save credentials if remember me is enabled
  //   _saveCredentialsIfNeeded();

  //   // Show remember me modal for first-time users after successful login
  //   if (!localStorage.hasAskedRememberMe()) {
  //     showRememberMeModalIfNeeded();
  //   }

  //   // Centralized routing
  //   _routeAfterLogin(emailVerified: emailVerified, profileComplete: profileComplete, user: result);
  //   final profileData = ProfileModel.fromJson(result);
  //   userController.setUser(profileData);

  //   // Reconnect socket with authentication after successful login
  //   _reconnectSocketWithAuth();

  //   handleSuccess(result["message"] ?? "Login successful", showSuccessSnackBar: true);
  //   isLoginLoading.value = false;
  // }

  // /// Handle successful social login - common logic for both traditional and new response formats
  // void _handleSuccessfulSocialLogin(Map<String, dynamic> result) {
  //   token = result["data"]["token"].toString();
  //   localStorage.saveAccessToken(token);

  //   userId = result["data"]["user"]["_id"]?.toString() ?? "";
  //   final emailVerified = _parseEmailVerified(result["data"]["user"]);
  //   final profileComplete = _parseProfileComplete(result["data"]["user"]);

  //   _routeAfterLogin(emailVerified: emailVerified, profileComplete: profileComplete, user: result);
  //   final profileData = ProfileModel.fromJson(result);
  //   userController.setUser(profileData);
  //   handleSuccess(result["message"] ?? "Login successful", showSuccessSnackBar: true);
  //   googleLoginLoading.value = false;
  // }

  // /// Validate email format
  // bool _isValidEmail(String email) {
  //   return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  // }

  // // ------------------------------------------------------------
  // // Detailed email validation with specific error messages
  // // ------------------------------------------------------------
  // String? getDetailedEmailError(String email) {
  //   if (email.isEmpty) return 'Email is required';

  //   // Check for @ symbol
  //   if (!email.contains('@')) {
  //     return 'Email must contain @ symbol';
  //   }

  //   // Check if email starts or ends with @
  //   if (email.startsWith('@')) {
  //     return 'Email cannot start with @';
  //   }
  //   if (email.endsWith('@')) {
  //     return 'Email cannot end with @';
  //   }

  //   // Split email into local and domain parts
  //   final parts = email.split('@');
  //   if (parts.length != 2) {
  //     return 'Email can only contain one @ symbol';
  //   }

  //   final localPart = parts[0];
  //   final domainPart = parts[1];

  //   // Validate local part
  //   if (localPart.isEmpty) {
  //     return 'Email username cannot be empty';
  //   }
  //   if (localPart.length > 64) {
  //     return 'Email username is too long (max 64 characters)';
  //   }
  //   if (localPart.startsWith('.') || localPart.endsWith('.')) {
  //     return 'Email username cannot start or end with a dot';
  //   }
  //   if (localPart.contains('..')) {
  //     return 'Email username cannot contain consecutive dots';
  //   }

  //   // Validate domain part
  //   if (domainPart.isEmpty) {
  //     return 'Email domain cannot be empty';
  //   }
  //   if (domainPart.length > 253) {
  //     return 'Email domain is too long (max 253 characters)';
  //   }
  //   if (domainPart.startsWith('.') || domainPart.endsWith('.')) {
  //     return 'Email domain cannot start or end with a dot';
  //   }
  //   if (domainPart.contains('..')) {
  //     return 'Email domain cannot contain consecutive dots';
  //   }

  //   // Check for valid domain structure
  //   if (!domainPart.contains('.')) {
  //     return 'Email domain must contain a dot (e.g., .com, .org)';
  //   }

  //   final domainParts = domainPart.split('.');
  //   if (domainParts.length < 2) {
  //     return 'Email domain must have a valid structure (e.g., example.com)';
  //   }

  //   // Validate TLD (top-level domain)
  //   final tld = domainParts.last;
  //   if (tld.length < 2) {
  //     return 'Email domain extension is too short';
  //   }
  //   if (tld.length > 6) {
  //     return 'Email domain extension is too long';
  //   }

  //   // Check for common invalid patterns
  //   final invalidPatterns = ['test@test', 'example@example', 'admin@admin', 'user@user', 'email@email', 'mail@mail', 'info@info', 'contact@contact'];

  //   if (invalidPatterns.contains(email.toLowerCase())) {
  //     return 'Please use a real email address';
  //   }

  //   // Check for consecutive special characters in local part
  //   if (RegExp(r'[._%+-]{2,}').hasMatch(localPart)) {
  //     return 'Email username cannot contain consecutive special characters';
  //   }

  //   // Final regex check
  //   final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  //   if (!emailRegex.hasMatch(email)) {
  //     return 'Please enter a valid email address';
  //   }

  //   return null; // Valid email
  // }

  // // ------------------------------------------------------------
  // // Real-time validation methods
  // // ------------------------------------------------------------
  // String? validateEmailRealTime(String email) {
  //   if (email.isEmpty) {
  //     return null; // Don't show error for empty field while typing
  //   }

  //   // Use detailed validation for better error messages
  //   return getDetailedEmailError(email);
  // }

  // String? validatePasswordRealTime(String password) {
  //   if (password.isEmpty) {
  //     return null; // Don't show error for empty field while typing
  //   }

  //   if (password.length < 8) {
  //     return 'Password must be at least 8 characters';
  //   }

  //   return null; // Valid password
  // }

  // String? validateFullNameRealTime(String name) {
  //   if (name.isEmpty) {
  //     return null; // Don't show error for empty field while typing
  //   }

  //   if (name.trim().length < 2) {
  //     return 'Full name must be at least 2 characters';
  //   }

  //   if (RegExp(r'[0-9]').hasMatch(name)) {
  //     return 'Full name should not contain numbers';
  //   }

  //   return null; // Valid name
  // }

  // // ------------------------------------------------------------
  // // Clear validation errors when user starts typing
  // // ------------------------------------------------------------
  // void clearFieldError(String fieldName) {
  //   if (errors.containsKey(fieldName)) {
  //     errors.remove(fieldName);
  //   }
  //   if (loginErrors.containsKey(fieldName)) {
  //     loginErrors.remove(fieldName);
  //   }
  //   if (signupErrors.containsKey(fieldName)) {
  //     signupErrors.remove(fieldName);
  //   }
  // }

  // void clearAllErrors() {
  //   errors.clear();
  //   loginErrors.clear();
  //   signupErrors.clear();
  // }

  // // ------------------------------------------------------------
  // // STEP 1: Sign up → Send OTP
  // // ------------------------------------------------------------
  // Future<void> signUp() async {
  //   try {
  //     isSignupLoading.value = true;

  //     // Clear previous errors
  //     signupErrors.clear();
  //     errors.clear();

  //     // Get FCM device token for notifications
  //     String deviceToken = notificationController.fcmToken.value;
  //     if (deviceToken.isEmpty) {
  //       deviceToken = await notificationController.getFcmToken() ?? "";
  //       print('Retrieved FCM token for signup: $deviceToken');
  //     }

  //     final result = await repo.signUp(
  //       email: emailController.text.trim(),
  //       password: passwordController.text,
  //       fullName: fullNameController.text.trim(),
  //       deviceToken: deviceToken,
  //       deviceType: Platform.isAndroid ? "Android" : "IOS",
  //     );
  //     clearLoading();

  //     // --- parse response ---
  //     // Expecting: { status:200, data:{ userId: "...", ... } }
  //     final status = result["status"];
  //     if (status == 200 || status == 201) {
  //       userId = result["data"]["user"]["_id"].toString();
  //       isOtpSent.value = true;
  //       handleSuccess("OTP sent to registered email", showSuccessSnackBar: true);
  //       isSignupLoading.value = false;

  //       signupStep.value = 2;
  //     } else {
  //       // Handle API validation errors
  //       final message = result["message"]?.toString() ?? "Signup failed";

  //       // Check for specific validation errors and set them in the errors map
  //       if (message.toLowerCase().contains("email")) {
  //         if (message.toLowerCase().contains("already exists")) {
  //           signupErrors['email'] = "An account with this email already exists. Please use a different email or try logging in.";
  //           errors['email'] = "An account with this email already exists. Please use a different email or try logging in.";
  //         } else if (message.toLowerCase().contains("invalid")) {
  //           signupErrors['email'] = "Please enter a valid email address";
  //           errors['email'] = "Please enter a valid email address";
  //         } else {
  //           signupErrors['email'] = message;
  //           errors['email'] = message;
  //         }
  //       } else if (message.toLowerCase().contains("password")) {
  //         signupErrors['password'] = message;
  //         errors['password'] = message;
  //       } else if (message.toLowerCase().contains("name") || message.toLowerCase().contains("fullname")) {
  //         signupErrors['fullName'] = message;
  //         errors['fullName'] = message;
  //       } else {
  //         // For general errors, show in snackbar
  //         Get.snackbar("Signup Error", message, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 4));
  //       }

  //       isSignupLoading.value = false;
  //     }
  //   } catch (e) {
  //     isSignupLoading.value = false;
  //     clearLoading();

  //     // Handle specific error types
  //     String errorMessage = e.toString();

  //     if (errorMessage.contains('network') || errorMessage.contains('connection')) {
  //       Get.snackbar(
  //         "Network Error",
  //         "Please check your internet connection and try again.",
  //         backgroundColor: Colors.orange,
  //         colorText: Colors.white,
  //         duration: Duration(seconds: 4),
  //       );
  //     } else if (errorMessage.contains('timeout')) {
  //       Get.snackbar("Timeout Error", "Request timed out. Please try again.", backgroundColor: Colors.orange, colorText: Colors.white, duration: Duration(seconds: 4));
  //     } else {
  //       // For other errors, show the actual error message
  //       Get.snackbar(
  //         "Signup Error",
  //         errorMessage.replaceFirst("Exception: ", "").replaceFirst("SocketException: ", ""),
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         duration: Duration(seconds: 4),
  //       );
  //     }
  //   }
  // }

  // // ------------------------------------------------------------
  // // STEP 2: OTP → Send OTP
  // // ------------------------------------------------------------
  // Future<bool> verifyOtp() async {
  //   final enteredOtp = otp.join();
  //   if (!_isOtpComplete(enteredOtp)) {
  //     errors['otp'] = 'Please enter a valid 6-digit OTP';
  //     Get.snackbar("Error", "Please enter a valid 6-digit OTP");
  //     return false;
  //   }

  //   try {
  //     isSignupLoading.value = true;
  //     final result = await repo.verifyOTPRepo(
  //       otp: enteredOtp,
  //       userId: userId, // backend likely requires it
  //     );
  //     isSignupLoading.value = false;

  //     final status = result["status"];
  //     if (status == 200 || status == 201) {
  //       token = result["data"]["token"].toString();
  //       localStorage.saveAccessToken(token);
  //       isOtpVerified.value = true;
  //       errors.remove('otp');

  //       // Get.to(() => isForgotPassword == true ? ResetPasswordScreen() : signupStep.value = 3, SignupScreen()) );

  //       if (isForgotPassword == true) {
  //         Get.to(() => ResetPasswordScreen());
  //       } else {
  //         signupStep.value = 3;
  //         Get.to(() => SignupScreen());
  //       }

  //       return true;
  //     } else {
  //       errors['otp'] = result["message"]?.toString() ?? "Invalid OTP";
  //       Get.snackbar("OTP Failed", errors['otp'] ?? "Invalid OTP");
  //       return false;
  //     }
  //   } catch (e) {
  //     isSignupLoading.value = false;

  //     // Handle specific OTP error cases
  //     String errorMessage = 'Error verifying OTP';

  //     if (e.toString().contains('OTP Expired')) {
  //       errorMessage = 'OTP has expired. Please request a new one.';
  //       errors['otp'] = errorMessage;
  //       clearOtpFields(); // Clear OTP fields for expired OTP
  //       Get.snackbar("OTP Expired", errorMessage, backgroundColor: Colors.orange, colorText: Colors.white, duration: Duration(seconds: 4));
  //     } else if (e.toString().contains('Invalid OTP')) {
  //       errorMessage = 'Invalid OTP. Please check and try again.';
  //       errors['otp'] = errorMessage;
  //       Get.snackbar("Invalid OTP", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //     } else if (e.toString().contains('Bad Request')) {
  //       // Handle other 400 errors
  //       final message = e.toString().replaceAll('BadRequestException: ', '');
  //       errorMessage = message.isNotEmpty ? message : 'Invalid request. Please try again.';
  //       errors['otp'] = errorMessage;
  //       Get.snackbar("Verification Failed", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //     } else {
  //       errors['otp'] = errorMessage;
  //       handleError(e);
  //     }

  //     return false;
  //   }
  // }

  // Future<void> resendOtp() async {
  //   try {
  //     final result = await repo.resendOTPRepo(email: emailController.text.trim());
  //     if (result["status"] == 200 || result["status"] == 201) {
  //       handleSuccess("OTP resent successfully", showSuccessSnackBar: true);
  //       // Clear any existing OTP errors when resending
  //       errors.remove('otp');
  //     } else {
  //       handleError(result["message"] ?? "Failed to resend OTP");
  //     }
  //   } catch (e) {
  //     // Handle specific resend OTP error cases
  //     String errorMessage = 'Failed to resend OTP';

  //     if (e.toString().contains('Bad Request')) {
  //       final message = e.toString().replaceAll('BadRequestException: ', '');
  //       errorMessage = message.isNotEmpty ? message : 'Invalid request. Please try again.';
  //     } else if (e.toString().contains('Too Many Requests')) {
  //       errorMessage = 'Too many attempts. Please wait before trying again.';
  //     } else if (e.toString().contains('Not Found')) {
  //       errorMessage = 'Email not found. Please check your email address.';
  //     }

  //     Get.snackbar("Resend Failed", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //   }
  // }

  // Future<void> forgotPassword() async {
  //   try {
  //     isForgotPasswordLoading.value = true;
  //     final result = await repo.forgotPasswordRepo(email: emailController.text.trim());
  //     if (result["status"] == 200 || result["status"] == 201) {
  //       userId = result["data"]["user"]["_id"].toString();
  //       handleSuccess("OTP sent successfully", showSuccessSnackBar: true);
  //       isForgotPasswordLoading.value = false;
  //       signupStep.value = 2;
  //       Get.to(() => const SignupScreen());
  //     } else {
  //       handleError(result["message"] ?? "Failed to send OTP");
  //       isForgotPasswordLoading.value = false;
  //     }
  //   } catch (e) {
  //     isForgotPasswordLoading.value = false;

  //     // Handle specific forgot password error cases
  //     String errorMessage = 'Failed to send OTP';

  //     if (e.toString().contains('Bad Request')) {
  //       final message = e.toString().replaceAll('BadRequestException: ', '');
  //       errorMessage = message.isNotEmpty ? message : 'Invalid request. Please try again.';
  //     } else if (e.toString().contains('Not Found')) {
  //       errorMessage = 'Email not found. Please check your email address.';
  //     } else if (e.toString().contains('Too Many Requests')) {
  //       errorMessage = 'Too many attempts. Please wait before trying again.';
  //     }

  //     Get.snackbar("Send Failed", errorMessage, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 3));
  //   }
  // }

  // Future<void> resetPassword() async {
  //   try {
  //     // ✅ Password length validation
  //     if (passwordController.text.trim().length < 8) {
  //       handleError("Password must be at least 8 characters long");
  //       return;
  //     }

  //     isResetPasswordLoading.value = true;

  //     final result = await repo.resetPasswordRepo(password: passwordController.text.trim());

  //     if (result["status"] == 200 || result["status"] == 201) {
  //       userId = result["data"]["user"]["_id"].toString();
  //       handleSuccess(result["message"], showSuccessSnackBar: true);
  //       isResetPasswordLoading.value = false;
  //       Get.to(() => LoginScreen());
  //     } else {
  //       handleError(result["message"] ?? "Failed to reset password");
  //       isResetPasswordLoading.value = false;
  //     }
  //   } catch (e) {
  //     isResetPasswordLoading.value = false;
  //     handleError(e);
  //   }
  // }

  // bool _isOtpComplete(String otpStr) => otpStr.length == 6 && !otp.any((d) => d.isEmpty);

  // /// Clear OTP fields for retry
  // void clearOtpFields() {
  //   for (int i = 0; i < otp.length; i++) {
  //     otp[i] = '';
  //     otpControllers[i].clear();
  //   }
  //   errors.remove('otp');
  //   // Focus on first OTP field after clearing
  //   if (otpFocusNodes.isNotEmpty) {
  //     otpFocusNodes[0].requestFocus();
  //   }
  // }

  // /// Handle OTP paste functionality
  // void handleOtpPaste(String pastedText, int currentIndex) {
  //   // Remove any non-numeric characters
  //   final numericOnly = pastedText.replaceAll(RegExp(r'[^\d]'), '');

  //   if (numericOnly.length <= 6) {
  //     // Clear all fields first
  //     for (int i = 0; i < otp.length; i++) {
  //       otp[i] = '';
  //       otpControllers[i].clear();
  //     }

  //     // Fill fields with pasted digits
  //     for (int i = 0; i < numericOnly.length && i < 6; i++) {
  //       otp[i] = numericOnly[i];
  //       otpControllers[i].text = numericOnly[i];
  //     }

  //     // Focus on the next empty field or last field if all filled
  //     final nextIndex = numericOnly.length < 6 ? numericOnly.length : 5;
  //     if (nextIndex < 6) {
  //       otpFocusNodes[nextIndex].requestFocus();
  //     }

  //     // Clear any existing errors
  //     errors.remove('otp');
  //   }
  // }

  // /// Clear login errors
  // void clearLoginErrors() {
  //   errors.remove('email');
  //   errors.remove('password');
  // }

  // void goToNextProfileStep() {
  //   if (profileSetupStep.value < 3) {
  //     profileSetupStep.value++;
  //   }
  // }

  // void goToPrevProfileStep() {
  //   if (profileSetupStep.value > 1) {
  //     profileSetupStep.value--;
  //   }
  // }

  // // Optional: auto-verify when all boxes filled
  // void checkOtpAutoVerify() {
  //   if (_isOtpComplete(otp.join())) {
  //     verifyOtp();
  //   }
  // }

  // /// Auto-login using stored bearer token
  // Future<void> autoLogin() async {
  //   try {
  //     isLoginLoading.value = true;

  //     final result = await repo.autoLoginRepo();

  //     if (result["status"] == 200 && result["data"] != null) {
  //       // Handle successful auto-login
  //       token = result["data"]["token"]?.toString() ?? "";
  //       if (token.isNotEmpty) {
  //         localStorage.saveAccessToken(token);
  //       }

  //       userId = result["data"]["user"]["_id"]?.toString() ?? "";
  //       final emailVerified = _parseEmailVerified(result["data"]["user"]);
  //       final profileComplete = _parseProfileComplete(result["data"]["user"]);

  //       // Check if user has incomplete profile setup
  //       if (!emailVerified || !profileComplete) {
  //         print("User has incomplete profile setup, redirecting to login screen");
  //         isLoginLoading.value = false;

  //         // Clear stored token and credentials to force fresh login
  //         localStorage.deleteAccessToken();
  //         localStorage.clearSavedCredentials();

  //         // Navigate to login screen so user can login with their credentials
  //         Get.offAll(() => OnboardingScreen());
  //         return;
  //       }

  //       // Update user data only if profile is complete
  //       final profileData = ProfileModel.fromJson(result);
  //       userController.setUser(profileData);

  //       // Reconnect socket with authentication after successful auto-login
  //       _reconnectSocketWithAuth();

  //       // Route user based on their status (should be complete at this point)
  //       _routeAfterLogin(emailVerified: emailVerified, profileComplete: profileComplete, user: result);

  //       handleSuccess(result["message"] ?? "Auto-login successful", showSuccessSnackBar: false);
  //       isLoginLoading.value = false;

  //       // Complete auto login for notification handler
  //       if (!autoLoginCompleter.isCompleted) {
  //         autoLoginCompleter.complete(true);
  //       }
  //     } else {
  //       // Handle auto-login failure
  //       final errorMessage = result["message"]?.toString() ?? "Auto-login failed";
  //       print("Auto-login failed: $errorMessage");
  //       isLoginLoading.value = false;

  //       // Clear stored token if auto-login fails
  //       localStorage.deleteAccessToken();

  //       // Complete auto login with failure for notification handler
  //       if (!autoLoginCompleter.isCompleted) {
  //         autoLoginCompleter.complete(false);
  //       }

  //       // Don't show error snackbar for auto-login failures
  //       // Just navigate to login screen
  //       Get.offAll(() => LoginScreen());
  //     }
  //   } catch (e) {
  //     isLoginLoading.value = false;
  //     print("Auto-login error: $e");

  //     // Clear stored token if auto-login fails
  //     localStorage.deleteAccessToken();

  //     // Complete auto login with failure for notification handler
  //     if (!autoLoginCompleter.isCompleted) {
  //       autoLoginCompleter.complete(false);
  //     }

  //     // Navigate to login screen silently
  //     Get.offAll(() => LoginScreen());
  //   }
  // }

  // /// Check if user has valid token for auto-login
  // bool canAutoLogin() {
  //   final token = localStorage.getAccessToken();
  //   return token != null && token.isNotEmpty;
  // }

  // // ========================================
  // // Remember Me Functionality
  // // ========================================

  // /// Load remember me settings on app start
  // void _loadRememberMeSettings() {
  //   rememberMe.value = localStorage.isRememberMeEnabled();

  //   // Load saved credentials if remember me is enabled
  //   if (rememberMe.value && localStorage.hasSavedCredentials()) {
  //     final savedEmail = localStorage.getSavedEmail();
  //     final savedPassword = localStorage.getSavedPassword();

  //     if (savedEmail != null && savedPassword != null) {
  //       loginEmailController.text = savedEmail;
  //       loginPasswordController.text = savedPassword;
  //       print("Loaded saved credentials for email: $savedEmail");
  //     }
  //   }
  // }

  // /// Toggle remember me preference
  // void toggleRememberMe(bool value) {
  //   rememberMe.value = value;
  //   localStorage.setRememberMe(value);

  //   if (!value) {
  //     // If remember me is disabled, clear saved credentials
  //     localStorage.clearSavedCredentials();
  //     print("Remember me disabled, cleared saved credentials");
  //   } else {
  //     print("Remember me enabled");
  //   }
  // }

  // /// Save credentials if remember me is enabled
  // void _saveCredentialsIfNeeded() {
  //   if (rememberMe.value) {
  //     localStorage.saveCredentials(email: loginEmailController.text.trim(), password: loginPasswordController.text);
  //     print("Credentials saved for remember me");
  //   }
  // }

  // /// Show remember me modal for first-time users
  // void showRememberMeModalIfNeeded() {
  //   if (!localStorage.hasAskedRememberMe()) {
  //     showRememberMeModal.value = true;
  //     print("Showing remember me modal for first-time user");
  //   }
  // }

  // /// Handle remember me modal response
  // void handleRememberMeModalResponse(bool shouldRemember) {
  //   toggleRememberMe(shouldRemember);
  //   localStorage.setHasAskedRememberMe(true);
  //   showRememberMeModal.value = false;

  //   if (shouldRemember) {
  //     _saveCredentialsIfNeeded();
  //   }

  //   print("User chose remember me: $shouldRemember");
  // }

  // /// Clear all saved login data including credentials
  // void clearLoginData() {
  //   loginEmailController.clear();
  //   loginPasswordController.clear();
  //   errors.clear();
  //   loginErrors.clear();

  //   // Don't clear remember me preference unless explicitly requested
  //   if (!rememberMe.value) {
  //     localStorage.clearSavedCredentials();
  //   }

  //   print("Login data cleared");
  // }

  // /// Clear remember me data (for logout)
  // void clearRememberMeData() {
  //   rememberMe.value = false;
  //   localStorage.clearCredentials();
  //   localStorage.setHasAskedRememberMe(false);
  //   print("Remember me data cleared");
  // }

  // /// Logout user and handle remember me preference
  // Future<void> logout({bool clearRememberMe = false}) async {
  //   try {
  //     isLoading.value = true;

  //     // Call the logout API
  //     final result = await repo.logoutRepo();

  //     if (result["status"] == 200 || result["status"] == 201) {
  //       Utils.logInfo('Logout API successful', name: 'AuthController');
  //     } else {
  //       Utils.logInfo('Logout API returned non-success status: ${result["status"]}', name: 'AuthController');
  //     }
  //   } catch (e) {
  //     // Log error but continue with logout process anyway
  //     Utils.logError('Logout API error: $e', name: 'AuthController');
  //   } finally {
  //     isLoading.value = false;
  //   }

  //   // Clear session data
  //   localStorage.deleteAccessToken();
  //   token = "";
  //   userId = "";

  //   // Clear form data
  //   loginEmailController.clear();
  //   loginPasswordController.clear();
  //   errors.clear();
  //   loginErrors.clear();

  //   // Handle remember me based on user preference
  //   if (clearRememberMe) {
  //     clearRememberMeData();
  //   } else if (!rememberMe.value) {
  //     // If remember me is disabled, clear saved credentials
  //     localStorage.clearSavedCredentials();
  //   }

  //   // Navigate to login screen
  //   Get.offAll(() => LoginScreen());
  //   print("User logged out, remember me preserved: ${!clearRememberMe}");
  // }

  // // ------------------------------------------------------------
  // // STEP 3: Create Profile
  // // ------------------------------------------------------------
  // // Future<void> createProfile() async {
  // //   if (!validateProfileStep()) ;

  // //   try {
  // //     isProfileLoading.value = true;

  // //     final result = await repo.createAccountRepo(
  // //         dateOfBirth: dobController.text,
  // //         gender: selectedGender.value.toLowerCase(),
  // //         profileVisibility: isPrivateProfile.value ? "private" : "public",
  // //         profilePhoto: profileImage.value?.path ?? "",
  // //         coverPhoto: coverImage.value?.path ?? "",
  // //         userId: userId,
  // //         bioVoice: audioUri.value,
  // //         deviceType: Platform.isAndroid ? "Android" : "iOS",
  // //         deviceToken: "fcmdevicetoken");
  // //     print(result);

  // //     if (result["status"] == 200 || result["status"] == 201) {
  // //       handleSuccess("Profile created successfully", showSuccessSnackBar: true);
  // //       isProfileLoading.value = false;
  // //       clearSignupData();
  // //       clearProfileData();
  // //       userId = result["data"]["user"]["_id"]?.toString() ?? "";
  // //       final profileId = result["data"]["profile"]["_id"]?.toString() ?? "";

  // //       Get.to(() => const MainNavigationScreen());
  // //       final profileResult = await repo.getProfileRepo(profileId: profileId);
  // //       final profileData = ProfileModel.fromJson(profileResult);
  // //       userController.setUser(profileData);

  // //       localStorage.saveAccessToken(result["data"]["token"].toString());
  // //     } else {
  // //       handleError(result["message"] ?? "Failed to create profile");
  // //       isProfileLoading.value = false;
  // //     }
  // //   } catch (e) {
  // //     isProfileLoading.value = false;

  // //     handleError(e);
  // //   }
  // // }
  // Future<void> createProfile() async {
  //   if (!validateProfileStep()) ;

  //   try {
  //     isProfileLoading.value = true;

  //     print('🎤 AuthController.createProfile - audioUri.value: ${audioUri.value}');
  //     print('🎤 AuthController.createProfile - hasRecordedBio.value: ${hasRecordedBio.value}');

  //     // Get FCM device token for notifications
  //     String deviceToken = notificationController.fcmToken.value;
  //     if (deviceToken.isEmpty) {
  //       deviceToken = await notificationController.getFcmToken() ?? "";
  //       print('Retrieved FCM token for create profile: $deviceToken');
  //     }

  //     final result = await repo.createAccountRepo(
  //       dateOfBirth: dobController.text,
  //       gender: selectedGender.value.toLowerCase(),
  //       profileVisibility: isPrivateProfile.value ? "private" : "public",
  //       profilePhoto: profileImage.value?.path,
  //       coverPhoto: coverImage.value?.path,
  //       userId: userId,
  //       bioVoice: audioUri.value,
  //       deviceType: Platform.isAndroid ? "Android" : "IOS",
  //       deviceToken: deviceToken,
  //     );

  //     print(result);

  //     if (result["status"] == 200 || result["status"] == 201) {
  //       final newUserId = result["data"]["user"]["_id"]?.toString() ?? "";

  //       userId = newUserId;
  //       localStorage.saveAccessToken(result["data"]["token"].toString());

  //       handleSuccess("Profile created successfully", showSuccessSnackBar: true);

  //       clearSignupData();
  //       clearProfileData();

  //       final profileData = ProfileModel.fromJson(result);
  //       userController.setUser(profileData);
  //       _reconnectSocketWithAuth();
  //       isProfileLoading.value = false;
  //       await Get.to(() => const MainNavigationScreen());
  //     } else {
  //       handleError(result["message"] ?? "Failed to create profile");
  //       isProfileLoading.value = false;
  //     }
  //   } catch (e) {
  //     isProfileLoading.value = false;
  //     handleError(e);
  //   }
  // }

  // bool validateProfileStep() {
  //   final newErrors = <String, String?>{};
  //   if (dobController.text.isNotEmpty && !validateDate(dobController.text)) {
  //     newErrors['dob'] = 'Please enter a valid date (MM/DD/YYYY) and ensure age ≥ 13 years';
  //   }
  //   errors.value = newErrors;
  //   return newErrors.isEmpty;
  // }

  // // ------------------------------------------------------------
  // // Validation helpers
  // // ------------------------------------------------------------
  // bool validateSignupStep1() {
  //   final newErrors = <String, String?>{};

  //   if (fullNameController.text.trim().isEmpty) {
  //     newErrors['fullName'] = 'Full name is required';
  //   } else {
  //     final nameError = validateFullNameRealTime(fullNameController.text.trim());
  //     if (nameError != null) {
  //       newErrors['fullName'] = nameError;
  //     }
  //   }

  //   final email = emailController.text.trim();
  //   if (email.isEmpty) {
  //     newErrors['email'] = 'Email is required';
  //   } else {
  //     final emailError = getDetailedEmailError(email);
  //     if (emailError != null) {
  //       newErrors['email'] = emailError;
  //     }
  //   }

  //   final pwd = passwordController.text;
  //   if (pwd.isEmpty) {
  //     newErrors['password'] = 'Password is required';
  //   } else {
  //     final passwordError = validatePasswordRealTime(pwd);
  //     if (passwordError != null) {
  //       newErrors['password'] = passwordError;
  //     }
  //   }

  //   signupErrors.value = newErrors;
  //   errors.value = newErrors;
  //   return newErrors.isEmpty;
  // }

  // bool validateSignupStep2() {
  //   final newErrors = <String, String?>{};
  //   if (dobController.text.isNotEmpty && !validateDate(dobController.text)) {
  //     newErrors['dob'] = 'Please enter a valid date (MM/DD/YYYY) and ensure you are at least 13 years old';
  //   }
  //   signupErrors.value = newErrors;
  //   errors.value = newErrors;
  //   return newErrors.isEmpty;
  // }

  // bool validateSignupStep3() {
  //   final newErrors = <String, String?>{};

  //   // Validate Date of Birth
  //   if (dobController.text.trim().isEmpty) {
  //     newErrors['dob'] = 'Date of birth is required';
  //   } else if (!validateDate(dobController.text.trim())) {
  //     newErrors['dob'] = 'Please enter a valid date (MM/DD/YYYY) and ensure you are at least 13 years old';
  //   }

  //   // Validate Gender
  //   if (selectedGender.value.isEmpty) {
  //     newErrors['gender'] = 'Please select your gender';
  //   }

  //   signupErrors.value = newErrors;
  //   errors.value = newErrors;
  //   return newErrors.isEmpty;
  // }

  // // --- Password strength (UI support) ---
  // int get passwordStrength {
  //   final password = passwordController.text;
  //   if (password.isEmpty) return 0;
  //   var strength = 0;
  //   if (password.length >= 8) strength++;
  //   if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
  //   if (RegExp(r'[0-9]').hasMatch(password)) strength++;
  //   if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) strength++;
  //   return strength;
  // }

  // String get strengthLabel {
  //   final s = passwordStrength;
  //   if (s == 0) return '';
  //   if (s == 1) return 'Weak';
  //   if (s == 2) return 'Fair';
  //   if (s == 3) return 'Good';
  //   return 'Strong';
  // }

  // Color getStrengthColor() {
  //   final s = passwordStrength;
  //   if (s == 0) return AppColors.neutralExtraLightGray;
  //   if (s == 1) return AppColors.errorPrimary;
  //   if (s == 2) return AppColors.warningPrimary;
  //   if (s >= 3) return AppColors.successPrimary;
  //   return AppColors.successPrimary;
  // }

  // // ------------------------------------------------------------
  // // DOB helpers
  // // ------------------------------------------------------------
  // bool validateDate(String dateString) {
  //   final dateRegex = RegExp(r'^(0[1-9]|1[0-2])[/\-\.](0[1-9]|[12]\d|3[01])[/\-\.](\d{4})$');
  //   if (!dateRegex.hasMatch(dateString)) return false;

  //   final parts = dateString.split(RegExp(r'[/\-\.]'));
  //   final month = int.parse(parts[0]);
  //   final day = int.parse(parts[1]);
  //   final year = int.parse(parts[2]);

  //   final testDate = DateTime(year, month, day);
  //   final today = DateTime.now();
  //   final minAge = DateTime(today.year - 13, today.month, today.day);

  //   final validDate = testDate.year == year && testDate.month == month && testDate.day == day;
  //   return validDate && testDate.isBefore(minAge);
  // }

  // String formatDob(DateTime d) => '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  // void selectDate(DateTime date) {
  //   selectedDate.value = date;
  //   dobController.text = formatDob(date);
  // }

  // // ------------------------------------------------------------
  // // Profile interaction
  // // ------------------------------------------------------------
  // void selectGender(String gender) => selectedGender.value = gender;
  // void togglePrivacy(bool isPrivate) => isPrivateProfile.value = isPrivate;

  // // ------------------------------------------------------------
  // // Media
  // // ------------------------------------------------------------
  // Future<void> pickImage(bool isProfile, {ImageSource? source}) async {
  //   try {
  //     ImageSource imageSource = source ?? ImageSource.gallery;

  //     // Skip permission request on iOS
  //     if (!Platform.isIOS) {
  //       final context = Get.context;
  //       if (context != null) {
  //         final utils = Utils();
  //         final hasPermission = await utils.requestImagePermission(context, imageSource);

  //         if (!hasPermission) {
  //           Get.snackbar(
  //             'Permission Required',
  //             imageSource == ImageSource.camera ? 'Camera permission is required to take photos' : 'Gallery permission is required to select photos',
  //             snackPosition: SnackPosition.BOTTOM,
  //           );
  //           return;
  //         }
  //       }
  //     }

  //     final XFile? image = await _imagePicker.pickImage(source: imageSource, maxWidth: 800, maxHeight: 800, imageQuality: 80);

  //     if (image != null) {
  //       if (isProfile) {
  //         profileImage.value = File(image.path);
  //       } else {
  //         coverImage.value = File(image.path);
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Error picking image: $e');
  //   }
  // }

  // Future<void> showImageSourceDialog(bool isProfile) async {
  //   Get.bottomSheet(
  //     Container(
  //       decoration: BoxDecoration(
  //         color: AppColors.neutralBlack,
  //         borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
  //         border: Border.all(color: AppColors.dividerColor.withOpacity(0.3), width: 1),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: 40,
  //             height: 4,
  //             margin: const EdgeInsets.only(top: 12, bottom: 20),
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //           Text(
  //             'Select Image Source',
  //             style: GoogleFonts.merriweather(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.neutralWhite),
  //           ),
  //           const SizedBox(height: 20),
  //           ListTile(
  //             leading: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
  //             ),
  //             title: Text(
  //               'Camera',
  //               style: GoogleFonts.merriweather(color: AppColors.neutralWhite, fontWeight: FontWeight.w500),
  //             ),
  //             subtitle: Text('Take a new photo', style: GoogleFonts.merriweather(color: AppColors.neutralWhite.withOpacity(0.7), fontSize: 14)),
  //             onTap: () {
  //               Get.back();
  //               pickImage(isProfile, source: ImageSource.camera);
  //             },
  //           ),
  //           ListTile(
  //             leading: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.photo_library, color: Colors.white, size: 20),
  //             ),
  //             title: Text(
  //               'Gallery',
  //               style: GoogleFonts.merriweather(color: AppColors.neutralWhite, fontWeight: FontWeight.w500),
  //             ),
  //             subtitle: Text('Choose from existing photos', style: GoogleFonts.merriweather(color: AppColors.neutralWhite.withOpacity(0.7), fontSize: 14)),
  //             onTap: () {
  //               Get.back();
  //               pickImage(isProfile, source: ImageSource.gallery);
  //             },
  //           ),
  //           const SizedBox(height: 20),
  //         ],
  //       ),
  //     ),
  //     backgroundColor: Colors.transparent,
  //   );
  // }

  // void removeImage(bool isProfile) {
  //   if (isProfile) {
  //     profileImage.value = null;
  //   } else {
  //     coverImage.value = null;
  //   }
  // }

  // // (Audio recording stubs unchanged)
  // void startRecording() => isRecording.value = true;
  // void cancelRecording() => isRecording.value = false;
  // void saveRecording(String uri, bool isAnonymous) {
  //   print('🎤 AuthController.saveRecording called with URI: $uri');
  //   isRecording.value = false;
  //   hasRecordedBio.value = true;
  //   audioUri.value = uri;
  //   print('🎤 AuthController.audioUri.value set to: ${audioUri.value}');
  // }

  // // ------------------------------------------------------------
  // // Clear
  // // ------------------------------------------------------------

  // void clearSignupData() {
  //   fullNameController.clear();
  //   emailController.clear();
  //   passwordController.clear();
  //   dobController.clear();
  //   otpController.clear();
  //   otp.assignAll(List.filled(6, ''));
  //   signupStep.value = 1;
  //   isOtpSent.value = false;
  //   isOtpVerified.value = false;
  //   signupErrors.clear();
  //   errors.clear();
  // }

  // void clearProfileData() {
  //   bioController.clear();
  //   usernameController.clear();
  //   profileSetupStep.value = 1;
  //   selectedGender.value = '';
  //   isPrivateProfile.value = false;
  //   isRecording.value = false;
  //   hasRecordedBio.value = false;
  //   profileImage.value = null;
  //   coverImage.value = null;
  //   audioUri.value = '';
  // }

  // String formatDateInput(String value) {
  //   if (value.isEmpty) return '';

  //   // Remove all non-numeric characters to get clean input
  //   final numbersOnly = value.replaceAll(RegExp(r'\D'), '');

  //   // Apply formatting based on length
  //   if (numbersOnly.length <= 2) {
  //     // MM
  //     return numbersOnly;
  //   } else if (numbersOnly.length <= 4) {
  //     // MM/DD
  //     return '${numbersOnly.substring(0, 2)}/${numbersOnly.substring(2)}';
  //   } else if (numbersOnly.length <= 8) {
  //     // MM/DD/YYYY
  //     final month = numbersOnly.substring(0, 2);
  //     final day = numbersOnly.substring(2, 4);
  //     final year = numbersOnly.substring(4);
  //     return '$month/$day/$year';
  //   } else {
  //     // Limit to 8 digits (MMDDYYYY)
  //     final month = numbersOnly.substring(0, 2);
  //     final day = numbersOnly.substring(2, 4);
  //     final year = numbersOnly.substring(4, 8);
  //     return '$month/$day/$year';
  //   }
  // }

  // /// Reconnect socket with authentication after successful login
  // void _reconnectSocketWithAuth() {
  //   try {
  //     // Check if ChatController is registered
  //     if (Get.isRegistered<ChatController>()) {
  //       final chatController = Get.find<ChatController>();
  //       chatController.retrySocketConnection();
  //       Utils.logInfo('Socket reconnection initiated after successful login', name: 'AuthController');
  //     }

  //     // Also directly reconnect SocketController if available
  //     if (Get.isRegistered<SocketController>()) {
  //       final socketController = Get.find<SocketController>();
  //       socketController.reconnectWithAuth();
  //       Utils.logInfo('Socket controller reconnected with auth', name: 'AuthController');
  //     }
  //   } catch (e) {
  //     Utils.logError('Error reconnecting socket after login: $e', name: 'AuthController');
  //   }
  // }

  // /// Generate support ticket
  // /// Returns true if successful, false otherwise
  // Future<bool> generateSupportTicket({required String email, required String type, required String subject, required String description}) async {
  //   try {
  //     Utils.logInfo('Generating support ticket', name: 'AuthController');
  //     isLoading.value = true;

  //     final response = await repo.generateSupportTicketRepo(email: email, type: type, subject: subject, description: description);

  //     isLoading.value = false;

  //     if (response != null) {
  //       Utils.logInfo('Support ticket generated successfully', name: 'AuthController');
  //       Get.snackbar(
  //         'Success',
  //         'Your support ticket has been submitted successfully!',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: AppColors.successPrimary,
  //         colorText: AppColors.neutralWhite,
  //         duration: const Duration(seconds: 3),
  //       );
  //       return true;
  //     }
  //     return false;
  //   } catch (error) {
  //     isLoading.value = false;
  //     Utils.logError('Error generating support ticket: $error', name: 'AuthController');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to submit support ticket. Please try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.errorPrimary,
  //       colorText: AppColors.neutralWhite,
  //       duration: const Duration(seconds: 3),
  //     );
  //     return false;
  //   }
  // }

  // handleNotificationFunction(RemoteMessage message) {
  //   NotificationHandler().handleNotificationFunction(message);
  // }

  // // handleNotificationFunction(RemoteMessage message) {
  // //   // NotificationHandler().handleNotificationFunction(message);
  // // }

  // void _showSupportTicketDialog() {
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: AppColors.neutralBlack,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusLarge)),
  //         child: Container(
  //           padding: const EdgeInsets.all(15),
  //           constraints: const BoxConstraints(maxWidth: 500),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Header
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Contact Support',
  //                       style: GoogleFonts.merriweather(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                         foreground: Paint()
  //                           ..shader = const LinearGradient(
  //                             colors: [Color(0xFFF7586C), Color(0xFFBF53F8)],
  //                             begin: Alignment.topLeft,
  //                             end: Alignment.bottomRight,
  //                           ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.close, color: AppColors.neutralWhite),
  //                       onPressed: () => Navigator.of(context).pop(),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 24),

  //                 // Email Field
  //                 Text(
  //                   'Email',
  //                   style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.neutralWhite),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 TextField(
  //                   controller: _emailController,
  //                   style: GoogleFonts.merriweather(color: AppColors.neutralWhite),
  //                   decoration: InputDecoration(
  //                     hintText: 'your.email@example.com',
  //                     hintStyle: GoogleFonts.merriweather(color: AppColors.neutralWhite.withOpacity(0.5)),
  //                     filled: true,
  //                     fillColor: AppColors.uiCard,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: const BorderSide(color: AppColors.brandPrimary),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Type Dropdown
  //                 Text(
  //                   'Issue Type',
  //                   style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.neutralWhite),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Obx(
  //                   () => DropdownButtonFormField<String>(
  //                     value: _selectedType.value,
  //                     dropdownColor: const Color.fromARGB(249, 24, 45, 49),
  //                     style: GoogleFonts.merriweather(color: AppColors.neutralWhite),
  //                     decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: AppColors.uiCard,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                         borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                         borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                         borderSide: const BorderSide(color: AppColors.brandPrimary),
  //                       ),
  //                     ),
  //                     items: const [
  //                       DropdownMenuItem(value: 'bug', child: Text('Bug Report')),
  //                       DropdownMenuItem(value: 'account_recovery', child: Text('Account Recovery')),
  //                       DropdownMenuItem(value: 'other', child: Text('Other')),
  //                     ],
  //                     onChanged: (value) {
  //                       _selectedType.value = value!;
  //                     },
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Subject Field
  //                 Text(
  //                   'Subject',
  //                   style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.neutralWhite),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 TextField(
  //                   controller: _subjectController,
  //                   style: GoogleFonts.merriweather(color: AppColors.neutralWhite),
  //                   decoration: InputDecoration(
  //                     hintText: 'Brief description of your issue',
  //                     hintStyle: GoogleFonts.merriweather(color: AppColors.neutralWhite.withOpacity(0.5)),
  //                     filled: true,
  //                     fillColor: AppColors.uiCard,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: const BorderSide(color: AppColors.brandPrimary),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Description Field
  //                 Text(
  //                   'Description',
  //                   style: GoogleFonts.merriweather(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.neutralWhite),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 TextField(
  //                   controller: _descriptionController,
  //                   maxLines: 5,
  //                   textInputAction: TextInputAction.done,
  //                   onSubmitted: (_) {
  //                     // Dismiss keyboard when Done is pressed
  //                     FocusScope.of(context).unfocus();
  //                   },
  //                   style: GoogleFonts.merriweather(color: AppColors.neutralWhite),
  //                   decoration: InputDecoration(
  //                     hintText: 'Please provide more details about your issue...',
  //                     hintStyle: GoogleFonts.merriweather(color: AppColors.neutralWhite.withOpacity(0.5)),
  //                     filled: true,
  //                     fillColor: AppColors.uiCard,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: BorderSide(color: AppColors.dividerColor.withOpacity(0.3)),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusMedium),
  //                       borderSide: const BorderSide(color: AppColors.brandPrimary),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),

  //                 // Submit Button
  //                 Obx(
  //                   () => Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                       gradient: const LinearGradient(colors: [Color(0xFFF7586C), Color(0xFFBF53F8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  //                       borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusLarge),
  //                     ),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.transparent,
  //                         foregroundColor: AppColors.neutralWhite,
  //                         padding: const EdgeInsets.symmetric(vertical: 14),
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LayoutConstants.borderRadiusLarge)),
  //                         textStyle: GoogleFonts.merriweather(fontSize: 16, fontWeight: FontWeight.bold),
  //                         elevation: 0,
  //                       ),
  //                       onPressed: isLoading.value
  //                           ? null
  //                           : () {
  //                               _submitSupportTicket();
  //                             },
  //                       child: isLoading.value
  //                           ? const SizedBox(
  //                               height: 20,
  //                               width: 20,
  //                               child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutralWhite)),
  //                             )
  //                           : const Text('Submit Ticket'),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _submitSupportTicket() async {
  //   // Validation
  //   if (_emailController.text.trim().isEmpty) {
  //     Get.snackbar('Error', 'Please enter your email', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.errorPrimary, colorText: AppColors.neutralWhite);
  //     return;
  //   }

  //   if (_subjectController.text.trim().isEmpty) {
  //     Get.snackbar('Error', 'Please enter a subject', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.errorPrimary, colorText: AppColors.neutralWhite);
  //     return;
  //   }

  //   if (_descriptionController.text.trim().isEmpty) {
  //     Get.snackbar('Error', 'Please provide a description', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.errorPrimary, colorText: AppColors.neutralWhite);
  //     return;
  //   }

  //   // Submit ticket
  //   final success = await generateSupportTicket(
  //     email: _emailController.text.trim(),
  //     type: _selectedType.value,
  //     subject: _subjectController.text.trim(),
  //     description: _descriptionController.text.trim(),
  //   );

  //   // Close dialog and clear form only if submission was successful
  //   if (success) {
  //     // Close dialog if it's open
  //     Get.close(1);

  //     // Clear form
  //     _emailController.clear();
  //     _subjectController.clear();
  //     _descriptionController.clear();
  //     _selectedType.value = 'other';
  //   }
  // }
}
