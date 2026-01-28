import 'dart:io';
import 'package:get_right/Local%20Storage/local_storage.dart';
import 'package:get_right/network/network_services.dart';
import 'package:get_right/repo/app_url.dart';
// import 'package:TogetherVoice/repo/auth_services.dart';

class AuthRepository {
  final _network = NetworkApiService();
  Future<dynamic> getProfileRepo({String? profileId}) async {
    String url = AppUrl.getProfile;

    // Add profile ID as query parameter if provided
    if (profileId != null && profileId.isNotEmpty) {
      url = '$url?id=$profileId';
    }

    final response = await _network.get(url);

    return response;
  }

  Future<dynamic> loginRepo({required String email, required String password, required String deviceType, required String deviceToken}) async {
    final response = await _network.post(AppUrl.signIn, {"email": email, "password": password, "deviceToken": deviceToken, "deviceType": deviceType});
    return response;
  }

  Future<dynamic> autoLoginRepo() async {
    // Get the bearer token from local storage
    final localStorage = LocalStorage();
    final bearerToken = localStorage.getAccessToken();

    if (bearerToken == null || bearerToken.isEmpty) {
      throw Exception('No bearer token found in local storage');
    }

    // Create custom headers with the initial token (not the bearer token)
    final headers = {'Content-Type': 'application/json', 'Authorization': 'ab6410c710c7ce43c36e37084a4b5205b0e1608477336023a8520c9f104398f9'};

    // Send the bearer token in the body
    final response = await _network.post(AppUrl.autoLogin, {"token": "bearer $bearerToken"}, headers: headers);

    return response;
  }

  Future<dynamic> signUp({required String email, required String password, required String fullName, required String deviceToken, required String deviceType}) async {
    final response = await _network.post(
      headers: {"Authorization": "ab6410c710c7ce43c36e37084a4b5205b0e1608477336023a8520c9f104398f9"},
      AppUrl.signUp,
      {"email": email, "password": password, "fullName": fullName, "deviceToken": deviceToken, "deviceType": deviceType},
    );
    return response;
  }

  Future<dynamic> createAccountRepo({
    required String dateOfBirth,
    required String gender,
    required String profileVisibility,
    String? profilePhoto,
    String? coverPhoto,
    required String userId,
    String? bioVoice,
    required String deviceType,
    required String deviceToken,
  }) async {
    final response = await _network.postMultipart(
      url: AppUrl.createAccount, // <-- FIXED

      files: {
        "profilePhoto": profilePhoto != null ? [File(profilePhoto)] : [],
        "coverPhoto": coverPhoto != null ? [File(coverPhoto)] : [],
        "bioVoice": bioVoice != null ? [File(bioVoice)] : [],
      },
      fields: {"dateOfBirth": dateOfBirth, "gender": gender, "profileVisibility": profileVisibility, "userId": userId, "deviceToken": deviceToken, "deviceType": deviceType},
    );
    return response;
  }

  Future<dynamic> resendOTPRepo({required String email}) async {
    final response = await _network.post(AppUrl.resedOTP, {"email": email});
    return response;
  }

  Future<dynamic> forgotPasswordRepo({required String email}) async {
    final response = await _network.post(AppUrl.forgotPassword, {"email": email});
    return response;
  }

  Future<dynamic> resetPasswordRepo({required String password}) async {
    final response = await _network.post(AppUrl.resetPassword, {"password": password});
    return response;
  }

  Future<dynamic> changePasswordRepo({required String oldPassword, required String newPassword}) async {
    final response = await _network.post(AppUrl.changePassword, {"oldPassword": oldPassword, "newPassword": newPassword});
    return response;
  }

  Future<dynamic> updateProfileRepo({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? profileVisibility,
    String? profilePhoto,
    String? coverPhoto,
    String? bioVoice,
  }) async {
    try {
      // Validate file paths before sending
      Map<String, List<File>> files = {};

      if (profilePhoto != null && profilePhoto.isNotEmpty) {
        final file = File(profilePhoto);
        if (await file.exists()) {
          files["profilePhoto"] = [file];
        }
      }

      if (coverPhoto != null && coverPhoto.isNotEmpty) {
        final file = File(coverPhoto);
        if (await file.exists()) {
          files["coverPhoto"] = [file];
        }
      }

      if (bioVoice != null && bioVoice.isNotEmpty) {
        final file = File(bioVoice);
        if (await file.exists()) {
          files["bioVoice"] = [file];
        }
      }

      // Prepare fields with proper validation
      Map<String, dynamic> fields = {};
      if (fullName != null && fullName.trim().isNotEmpty) {
        fields["fullName"] = fullName.trim();
      }
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        fields["dateOfBirth"] = dateOfBirth;
      }
      if (gender != null && gender.isNotEmpty) {
        fields["gender"] = gender;
      }
      if (profileVisibility != null && profileVisibility.isNotEmpty) {
        fields["profileVisibility"] = profileVisibility;
      }

      final response = await _network.postMultipart(url: AppUrl.updateProfile, files: files, fields: fields);

      return response;
    } catch (e) {
      print("Update profile error: $e");
      rethrow;
    }
  }

  Future<dynamic> getVoicePostsRepo({required String profileId, required int page, required int limit, String? type}) async {
    final Map<String, String> params = {'page': page.toString(), 'limit': limit.toString()};

    // Add type parameter if provided (for "Following" tab)
    if (type != null && type.isNotEmpty) {
      params['type'] = type;
    }

    // Only add profile parameter if it's not empty (for profile-specific posts)
    if (profileId.isNotEmpty) {
      params['profile'] = profileId;
    }

    final response = await _network.get(AppUrl.voicePosts, params: params);
    return response;
  }

  /// Get other user's profile
  Future<dynamic> getOtherUserProfileRepo({required String userId}) async {
    final response = await _network.get('${AppUrl.getProfile}?id=$userId');
    return response;
  }

  /// Get other user's voice posts
  Future<dynamic> getOtherUserVoicePostsRepo({required String userId, required int page, required int limit}) async {
    final Map<String, String> params = {'page': page.toString(), 'limit': limit.toString(), 'profile': userId};

    final response = await _network.get(AppUrl.voicePosts, params: params);
    return response;
  }

  /// Follow a user
  Future<dynamic> followUserRepo({required String userId}) async {
    final response = await _network.post('${AppUrl.baseUrl}/follow/$userId', {});
    return response;
  }

  /// Unfollow a user
  Future<dynamic> unfollowUserRepo({required String userId}) async {
    final response = await _network.delete('${AppUrl.baseUrl}/follow/$userId');
    return response;
  }

  /// Follow/Unfollow toggle
  Future<dynamic> followToggleRepo({required String userId}) async {
    final response = await _network.post('${AppUrl.baseUrl}/follow/follow-toggle', {'user': userId});
    return response;
  }

  Future<dynamic> createVoicePostRepo({
    required String audioFilePath,
    required bool anonymous,
    required int duration, // Required duration parameter
    String? communityId, // Optional community ID for community posts
    List<String>? tagIds, // Optional tag IDs for community posts
  }) async {
    final Map<String, String> fields = {
      "anonymous": anonymous.toString(),
      "duration": duration.toString(), // Convert duration to string
    };

    // Add community ID if provided
    if (communityId != null && communityId.isNotEmpty) {
      fields["community"] = communityId;
    }

    // Add tag IDs if provided (send as individual fields for multipart)
    if (tagIds != null && tagIds.isNotEmpty) {
      for (int i = 0; i < tagIds.length; i++) {
        fields["tags[$i]"] = tagIds[i];
      }
    }

    final response = await _network.postMultipart(
      url: AppUrl.createVoicePost,
      files: {
        "audio": audioFilePath.isNotEmpty ? [File(audioFilePath)] : [],
      },
      fields: fields,
    );
    return response;
  }

  Future<dynamic> bookmarkPostRepo({required String postId}) async {
    final response = await _network.post('${AppUrl.createVoicePost}/$postId/bookmark', {});
    return response;
  }

  Future<dynamic> getBookmarkedPostsRepo({int page = 1, int limit = 10}) async {
    final Map<String, String> params = {'page': page.toString(), 'limit': limit.toString()};

    final response = await _network.get('${AppUrl.voicePosts}/bookmarks', params: params);

    print("AuthRepository: getBookmarkedPostsRepo response: $response");
    return response;
  }

  Future<dynamic> verifyOTPRepo({required String otp, required String userId}) async {
    final response = await _network.post(AppUrl.verifyOTP, {"otp": otp, "userId": userId});
    return response;
  }

  /// Logout repository method
  Future<dynamic> logoutRepo() async {
    try {
      print("AuthRepository: logoutRepo called");

      final response = await _network.post(AppUrl.logout, {});

      print("AuthRepository: logoutRepo response: $response");
      return response;
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }
}
