class ApiConstants {
  // static const String baseUrl = "https://helpmespeak.onrender.com";
   static const String baseUrl = "http://10.10.7.116:8000";

  // endpoints
  static const String login = "/api/auth/login/";
  static const String signup = "/api/auth/register/";
  static const String otpVerify = "/api/auth/otp/verify/";
  static const String home = "/api/auth/me/";
  static const String chatbot = "/api/chat/";
  static const String translate = "/tts/translatetts/";

  // 🔹 Phrasebook
  static const String categories = "/api/category-names/";
  static const String phrases = "/api/phrases/";
}
