class ApiConstants {
  // static const String baseUrl = "https://helpmespeak.onrender.com";
  static const String baseUrl = "http://10.10.7.116:8000";
  //static const String baseUrl = "https://api.taskmama.app";
  //static const String baseUrl = "http://192.168.10.113:8000";

  // Auth
  //static const String login = "/user/api/v1/user/login/";
  static const String login = "/api/auth/login/";
  static const String signup = "/api/auth/register/";
  static const String otpVerify = "/api/auth/otp/verify/";

  // Chat & Translate
  static const String chatbot = "/api/chat/";
  static const String translate = "/tts/translatetts/";

  // Phrasebook
  static const String categories = "/api/category-names/";
  static const String phrases = "/api/phrases/";

  // Profile
  static const String profile = "/api/auth/me/";
}
