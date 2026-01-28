import 'dart:developer';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_right/utils%20copy/utils.dart';
import 'package:get_right/network/response/api_response.dart';

/// The `BaseViewModelGetXController` provides common functionality for handling
/// API responses, loading states, and error handling.
abstract class BaseController extends GetxController {
  // API response state
  ApiResponse apiResponse = ApiResponse.init();
  bool isSecondLoading = false;

  /// Set the API response state and notify listeners.
  void setApiResponse(ApiResponse response) {
    apiResponse = response;
    update();
  }

  /// Set the API response state to loading.
  void setLoading() {
    setApiResponse(ApiResponse.loading());
  }

  void setSecondLoading(bool b) {
    isSecondLoading = b;
    update();
  }

  /// Handle errors by logging them and setting the error state.
  void handleError(dynamic e, {bool showErrorSnackBar = true, bool isSecondLoading = false}) {
    log("Error: $e");
    if (showErrorSnackBar) {
      Utils.errorBar(e.toString().replaceFirst("SocketException: ", "").replaceFirst("Exception: ", ""));
    }
    if (isSecondLoading) {
      setSecondLoading(false);
    } else {
      setApiResponse(ApiResponse.error(e.toString()));
    }
  }

  /// Show a success message and perform additional success logic.
  void handleSuccess(String message, {bool showSuccessSnackBar = false, Map<String, dynamic>? data, bool isSecondLoading = false}) {
    log("Success: $message");
    // Add success handling (like showing a success snackbar) here
    if (showSuccessSnackBar) {
      Utils.successBar(message);
    }
    if (isSecondLoading) {
      setSecondLoading(false);
    } else {
      setApiResponse(ApiResponse.completed(data ?? message));
    }
  }

  /// Optional: Override this method to perform actions when closing the controller.
  @override
  void onClose() {
    super.onClose();
    log('BaseViewModelGetXController is being disposed.');
  }
}
