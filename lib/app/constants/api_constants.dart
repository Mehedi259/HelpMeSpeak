class ApiConstants {

  static const String baseUrl = "https://app.helpmespeak.app";

  // Auth
  static const String login = "/api/auth/login/";
  static const String signup = "/api/auth/register/";
  static const String otpVerify = "/api/auth/otp/verify/";
  static const String forgotPassword = "/api/auth/password/forgot/";
  static const String resetPasswordVerify = "/api/auth/password/reset/verify/";
  static const String resetPasswordConfirm = "/api/auth/password/reset/confirm/";

  // Chat & Translate
  static const String chatbot = "/api/chat/";
  static const String translate = "/tts/translatetts/";

  // Phrasebook
  static const String categories = "/api/category-names/";
  static const String phrases = "/api/phrases/";

  // Profile
  static const String profile = "/api/auth/me/";
}
