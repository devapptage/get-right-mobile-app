class AppUrl {
  // development url
  static const String baseUrl = 'http://api.voicecast.thesuitchstaging2.com:4627/api/v1';
  static const String imnageUrl = 'http://api.voicecast.thesuitchstaging2.com:4627';
  static const String socketUrl = 'http://api.voicecast.thesuitchstaging2.com:4627';

  // client url

  // port url

  // end points
  static String getProfile = '$baseUrl/auth/profile';
  static String signUp = '$baseUrl/auth/signup';
  static String createAccount = '$baseUrl/auth/create-profile';
  static String verifyOTP = '$baseUrl/auth/verify-otp';
  static String signIn = '$baseUrl/auth/login';
  static String autoLogin = '$baseUrl/auth/auto-login';
  static String resedOTP = '$baseUrl/auth/send-otp';
  static String forgotPassword = '$baseUrl/auth/forget';
  static String resetPassword = '$baseUrl/auth/forget-password';
  static String updateProfile = '$baseUrl/auth/update-profile';
  static String changePassword = '$baseUrl/auth/change-password';
  static String voicePosts = '$baseUrl/voice-posts';
  static String createVoicePost = '$baseUrl/voice-posts';

  /////////logout API//
  static String logout = '$baseUrl/auth/logout';
}
