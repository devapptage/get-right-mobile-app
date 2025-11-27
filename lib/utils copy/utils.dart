import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class Utils {
  // static deepLinkShare({required String type, required String postId}) {
  //   Share.share(
  //       'Hey! I found something amazing. Check this out: https://pley-production.web.app/refer/?type=$type&socialId=$postId');
  //   Utils.logSuccess(
  //       "Url: https://pley-production.web.app/refer/?type=$type&socialId=$postId");
  // }
  getAddressFromLatLng(lat, long) async {
    double longitudee = long;
    double latitudee = lat;
    final placemarks = await placemarkFromCoordinates(latitudee, longitudee);
    if (placemarks.isNotEmpty) {
      final placemark = placemarks[0];
      String completeAddress = '${placemark.street},${placemark.subLocality},${placemark.locality}, ${placemark.administrativeArea}  ${placemark.country}';

      print('Locationnnnn is $completeAddress');
      return completeAddress;
    }
    return "Unable to get address";
  }

  static logSuccess(String msg, {String? name}) {
    log('\x1B[32m$msg\x1B[0m', name: name != null ? '\x1B[32m$name\x1B[0m' : "");
  }

  static logError(String msg, {String? name}) {
    log('\x1B[31m$msg\x1B[0m', name: name != null ? '\x1B[31m$name\x1B[0m' : "");
  }

  static logInfo(String msg, {String? name}) {
    log('\x1B[37m$msg\x1B[0m', name: name != null ? '\x1B[37m$name\x1B[0m' : "");
  }

  static Widget showEmptyError({required String title, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.secondary, width: 2),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.white, size: 40),
            10.h.verticalSpace,
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            5.h.verticalSpace,
            Text(
              subtitle,
              style: TextStyle(fontSize: 15.sp, color: AppColors.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // static Future firstTimeSetup({
  //   required Function() onFirstTime,
  //   required Function() onNotFirstTime,
  // }) async {
  //   try {
  //     bool? isFirstTime = LocalStorage.readJson(key: lsk.isFirstTime);

  //     logSuccess('Read isFirstTime value from local storage: $isFirstTime');

  //     if (isFirstTime == null) {
  //       logSuccess('First time setup logic is executed.');
  //       onFirstTime();
  //       LocalStorage.saveJson(key: lsk.isFirstTime, value: false);

  //       bool? updatedValue = LocalStorage.readJson(key: lsk.isFirstTime);
  //       logSuccess('Updated isFirstTime value in local storage to $updatedValue.');
  //     } else {
  //       logSuccess('Non-first-time setup logic is executed.');
  //       onNotFirstTime();
  //     }
  //   } catch (e) {
  //     logError('An error occurred in firstTimeSetup: $e');
  //   }
  // }

  static selectMultipleImages(BuildContext context, {required Function(List<File>) imagesData}) async {
    List<File> pickedFiles = [];
    if (pickedFiles.length >= 5) {
      // Ensure you're passing the context and handling the toast display properly
      Utils.toastMessage("You can only upload up to 5 images.", context);
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      int remainingSlots = 5 - pickedFiles.length;
      List<File> selectedFiles = result.paths.map((path) => File(path!)).toList().take(remainingSlots).toList();

      pickedFiles.addAll(selectedFiles);

      imagesData(pickedFiles);
    } else {
      // You can show a toast here if the user cancels the picker
      Utils.toastMessage("User canceled the picker.", context);
    }
  }

  static selectImagePickerTypeModal({required BuildContext context, required Function(List<PlatformFile>) onFileSelected}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Get.close(1);

                  final XFile? result = await ImagePicker().pickImage(source: ImageSource.camera);

                  if (result != null) {
                    File file = File(result.path);
                    PlatformFile platformFile = PlatformFile(path: result.path, name: file.path.split('/').last, size: await file.length(), bytes: await file.readAsBytes());

                    int sizeInBytes = platformFile.size;
                    double sizeInMb = sizeInBytes / (1024 * 1024);

                    if (sizeInMb < 100) {
                      // Use the callback to pass the selected file back to the parent
                      onFileSelected([platformFile]);
                      log("Selected File List from Camera ${File(platformFile.path!)}");
                    } else {
                      Get.snackbar("Error", 'Captured image is too large');
                    }
                  } else {
                    Get.snackbar("Error", "No image selected");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Get.close(1);
                  pickMultipleFiles(onFileSelected: onFileSelected);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static selectDate(BuildContext context, {required Function(DateTime) onDateSelected, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate ?? DateTime(1900), lastDate: lastDate ?? DateTime(2040));
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  static selectTime(BuildContext context, {required Function(DateTime) onTimeSelected, TimeOfDay? initialTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime ?? TimeOfDay.now());

    if (pickedTime != null) {
      // Construct a DateTime object with the current date and selected time
      final DateTime selectedTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, pickedTime.hour, pickedTime.minute);

      // Trigger the callback with the selected time
      onTimeSelected(selectedTime);
    }
  }

  static Future<void> pickProfileImage({required ImageSource source, required Function(File) onFileSelected}) async {
    ImagePicker picker = ImagePicker();
    File? selectedFile;
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
        onFileSelected(selectedFile);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  static pickMultipleFiles({required Function(List<PlatformFile>) onFileSelected}) async {
    try {
      FilePickerResult? result;

      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          allowMultiple: true, // Enable multiple file selection

          type: FileType.media,
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true, // Enable multiple file selection
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['mp4', 'png', 'jpeg', 'jpg'],
        );
      }

      if (result != null) {
        List<PlatformFile> newFiles = [];

        for (var element in result.files) {
          int sizeInBytes = element.size;
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb < 100) {
            newFiles.add(element);
            log("Selected File List ${File(element.path!)}");
          } else {
            Get.snackbar("Error", 'Selected file is too large');
          }
        }

        // Use the callback to pass the new files back to the parent
        onFileSelected(newFiles);
      }
    } catch (e) {
      print(e);
    }
  }

  static successBar(String message) {
    return Get.snackbar("Success", snackPosition: SnackPosition.TOP, message, backgroundColor: AppColors.onBackground, colorText: Colors.white);
  }

  static errorBar(String message) {
    return Get.snackbar(
      "Error",
      snackPosition: SnackPosition.TOP,
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.onError,
      margin: EdgeInsets.only(bottom: 10.h),
    );
  }

  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //! fluttertoast:
  static toastMessage(String message, BuildContext? context) {
    if (context != null) {
      FToast toast = FToast();
      toast.init(context);
      toast.removeCustomToast();
      toast.showToast(
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.height * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(24)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SvgPicture.asset(
              //   AppAssets.applogo,
              //   height: 25.h,
              // ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  static toastMessageWithButton({required String message, required BuildContext? context, required Function() onTap}) {
    if (context != null) {
      FToast toast = FToast();
      toast.init(context);
      toast.removeCustomToast();
      toast.showToast(
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.height * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(24)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SvgPicture.asset(
              //   AppAssets.applogo,
              //   height: 25.h,
              // ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              100.w.horizontalSpace,
              GestureDetector(
                onTap: onTap,
                child: const Text("Undo", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
  }

  static showSnack(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating, //! For Bottom
      ),
    );
  }

  static showLoaderAlert(BuildContext context) {
    Get.dialog(
      // context: context,
      // barrierDismissible: false,
      // : (BuildContext context) {
      const Center(child: CircularProgressIndicator(color: Colors.yellow)),
      // },
    );
  }

  static closeShowLoaderAlert(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static showLoading({double height = 25, double width = 25, Color? color}) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(color: color ?? Colors.yellow, strokeWidth: 2.w),
        ),
      ),
    );
  }

  static bool isEmail(String email) {
    String r = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(r, caseSensitive: false);

    return !regExp.hasMatch(email);
  }

  static bool isPhone(String phone) {
    // String r = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String r = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

    RegExp regExp = RegExp(r);

    return !regExp.hasMatch(phone);
  }

  static bool validateEmail(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter your email address", context);
      return false;
    } else if (Utils.isEmail(value.text)) {
      Utils.toastMessage("Please enter a valid email", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validatePhone(TextEditingController value, String type, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter your $type number", context);
      return false;
    } else if (Utils.isPhone(value.text)) {
      Utils.toastMessage("Please enter a valid $type Number", context);
      return false;
    } else if (value.text.length < 8) {
      Utils.toastMessage("$type Number length should be greater than 8 digits", context);
      return false;
    } else if (value.text.length > 15) {
      Utils.toastMessage("$type Number length should be less than 15 digits", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validatePassword(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Password is required", context);
      return false;
    } else if (value.text.length < 8) {
      Utils.toastMessage("Password must contain at least 8 characters", context);
      return false;
    } else if (value.text.length > 16) {
      Utils.toastMessage("Password length should be less than 16", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateNewPassword(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter new Password", context);
      return false;
    } else if (value.text.length < 8) {
      Utils.toastMessage("Password must contain at least 8 characters", context);
      return false;
    } else if (value.text.length > 16) {
      Utils.toastMessage("Password length should be less than 16", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateCurrentPassword(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter current password", context);
      return false;
    } else if (value.text.length < 8) {
      Utils.toastMessage("Password must contain at least 8 characters", context);
      return false;
    } else if (value.text.length > 16) {
      Utils.toastMessage("Password length should be less than 16", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateExistingPassword(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter your password", context);
      return false;
    } else if (value.text.length < 8) {
      Utils.toastMessage("Password length must be 8 characters", context);
      return false;
    } else if (value.text.length > 16) {
      Utils.toastMessage("Current password is incorrect", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateConfirmPassword(TextEditingController value1, TextEditingController value2, BuildContext context) {
    if (value2.text.isEmpty) {
      Utils.toastMessage("Please enter Confirm Password", context);
      return false;
    } else if (value1.text != value2.text) {
      Utils.toastMessage("Confirm password doesn’t match", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validate(TextEditingController value, String type, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter your $type", context);
      return false;
    } else {
      return true;
    }
  }

  static bool isFullName(String name) {
    String r = r'^[a-z A-Z,.\-]+$';
    RegExp regExp = RegExp(r);

    return !regExp.hasMatch(name);
  }

  static bool validateFullName(TextEditingController value, BuildContext context) {
    if (value.text.isEmpty) {
      Utils.toastMessage("Please enter your full name", context);
      return false;
    } else if (isFullName(value.text)) {
      Utils.toastMessage("Please enter a valid full name", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateBirthDay(DateTime? dateTime, BuildContext context) {
    if (dateTime == null) {
      Utils.toastMessage("Please select Date of Birth", context);

      return false;
    } else if (dateTime.add(const Duration(days: 365 * 18)).isAfter(DateTime.now())) {
      Utils.toastMessage("You should be at least 18 year old", context);
      return false;
    } else {
      return true;
    }
  }

  static bool validateOtp(String value, context, int otpLength) {
    if (value.isEmpty) {
      Utils.toastMessage("OTP is required", context);
      if (kDebugMode) {
        print(value);
      }
      return false;
    } else if (value.trim().length != otpLength) {
      Utils.toastMessage("Please enter a valid $otpLength-digit OTP", context);
      if (kDebugMode) {
        print(value);
      }
      return false;
    } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      Utils.toastMessage("OTP should contain only numbers", context);
      if (kDebugMode) {
        print(value);
      }
      return false;
    }
    return true;
  }
  // static String formattedTime({required int timeInSecond}) {
  //   int sec = timeInSecond % 60;
  //   int min = (timeInSecond / 60).floor();
  //   String minute = min.toString().length <= 1 ? "0$min" : "$min";
  //   String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  //   return "$minute : $second";
  // }

  static String formattedTime({required int timeInSecond}) {
    int hours = (timeInSecond / 3600).floor();
    int remainingSeconds = timeInSecond % 3600;
    int minutes = (remainingSeconds / 60).floor();
    int seconds = remainingSeconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return hours != 0 ? "$hoursStr:$minutesStr:$secondsStr" : "$minutesStr:$secondsStr";
  }

  static double distanceInMile(int? distanceInMeter) {
    if (distanceInMeter == null) {
      return 0;
    } else {
      return distanceInMeter / 1609.344;
    }
  }

  // static double distanceInMile(String distance) {
  //   double distanceInDouble = 0.0;
  //   distance = distance.trim();

  //   if (distance.contains("mile")) {
  //     distanceInDouble = double.parse(distance.split(' ').first);
  //   } else if (distance.contains("km")) {
  //     distanceInDouble = double.parse(distance.split(' ').first) / 1.609344;
  //   } else if (distance.contains("m")) {
  //     distanceInDouble = double.parse(distance.split(' ').first) / 1609.344;
  //   }
  //   // log("<<<<<<<<<<<<<<<dist#$distanceInDouble>>>>>>>>>of#$distance>>>>>>");
  //   return distanceInDouble;
  // }

  static double timeInMin(String time) {
    double timeInDouble = 0.0;
    time = time.trim();

    if (time.contains("mins")) {
      timeInDouble = double.parse(time.split(' ').first);
    } else if (time.contains("secs")) {
      timeInDouble = double.parse(time.split(' ').first) * 0.0166667;
    } else if (time.contains("hours")) {
      timeInDouble = double.parse(time.split(' ').first) * 60;
    }
    // log("<<<<<<<<<<<<<<<time#$timeInDouble>>>>>>>>>of#$time>>>>>>");

    return timeInDouble;
  }

  static closeKeyBoard(context) {
    FocusScope.of(context).unfocus();
  }

  static Future<void> openDialer({required String number}) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri);
    }
  }

  static NoSpecialCharAndEmojiTextInputFormatter noEmojiInputFormatter() {
    return NoSpecialCharAndEmojiTextInputFormatter();
  }

  static Future<void> launchUrl({required String url}) async {
    if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
      await url_launcher.launchUrl(Uri.parse(url));
    }
  }

  // static Future<void> saveToLocal(
  //     {required String key, required String value}) async {
  //   const FlutterSecureStorage storage = FlutterSecureStorage();
  //   await storage.write(key: key, value: value);
  // }

  // static Future<String> getFromLocal({required String key}) async {
  //   const FlutterSecureStorage storage = FlutterSecureStorage();
  //   return await storage.read(
  //         key: key,
  //       ) ??
  //       '';
  // }
  /// Requests camera permission./// Requests camera permission and shows a dialog if permission is permanently denied.
  Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      print("Camera permission granted");
      return true;
    } else if (status.isDenied) {
      print("Camera permission denied");
      return false;
    } else if (status.isPermanentlyDenied) {
      print("Camera permission permanently denied");
      // Show dialog to open app settings
      _showPermissionDialog(context, "Camera Access", "We need access to your camera to take profile photos.");
      return false;
    } else {
      return false;
    }
  }

  /// Requests gallery permission and shows a dialog if permission is permanently denied.
  Future<bool> requestGalleryPermission(BuildContext context) async {
    // For Android 13+, we need to request different permissions
    PermissionStatus status;
    if (Platform.isAndroid) {
      // Try READ_MEDIA_IMAGES first (Android 13+)
      status = await Permission.photos.request();
      if (status.isDenied) {
        // Fallback to READ_EXTERNAL_STORAGE for older versions
        status = await Permission.storage.request();
      }
    } else {
      // iOS
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      print("Gallery permission granted");
      return true;
    } else if (status.isDenied) {
      print("Gallery permission denied");
      return false;
    } else if (status.isPermanentlyDenied) {
      print("Gallery permission permanently denied");
      // Show dialog to open app settings
      _showPermissionDialog(context, "Gallery Access", "We need access to your gallery to select photos for your profile.");
      return false;
    } else {
      return false;
    }
  }

  /// Requests appropriate permissions for image picking based on source
  Future<bool> requestImagePermission(BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera) {
      return await requestCameraPermission(context);
    } else {
      return await requestGalleryPermission(context);
    }
  }

  Future<bool> requestStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      print("manageExternalStorage permission granted");
      return true;
    } else if (status.isDenied) {
      print("manageExternalStorage permission denied");
      return false;
    } else if (status.isPermanentlyDenied) {
      print("manageExternalStorage permission permanently denied");
      // Show dialog to open app settings
      _showPermissionDialog(context, "Storage Access", "We need storage access to manage your files.");
      return false;
    } else {
      return false;
    }
  }

  /// Shows a dialog prompting the user to open app settings.
  void _showPermissionDialog(BuildContext context, [String? title, String? message]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Permission Required"),
          content: Text(
            message ??
                "This permission is required for using this feature. "
                    "Please enable it in the app settings.",
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  static void showTostify(String s, String t) {}
}

class NoSpecialCharAndEmojiTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp(
      r'[^\w\s]', // This will remove anything that is not a word character or whitespace
      unicode: true,
    );

    final emojiRegExp = RegExp(
      // Match any emoji
      r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{2300}-\u{23FF}\u{2B50}\u{1F004}-\u{1F0CF}\u{2B06}\u{2934}\u{2935}\u{25AA}-\u{25AB}\u{25FE}\u{2B1B}\u{2B1C}\u{25FD}\u{25FB}\u{2614}\u{2615}\u{260E}\u{231A}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{25AA}-\u{25AB}\u{1F004}\u{1F0CF}]',
      unicode: true,
    );

    // Replace both emojis and special characters
    String newText = newValue.text.replaceAll(emojiRegExp, '');
    newText = newText.replaceAll(regex, '');

    return TextEditingValue(text: newText, selection: newValue.selection);
  }
}

String fetchedStartTime = '';
String fetchedEndTime = '';
