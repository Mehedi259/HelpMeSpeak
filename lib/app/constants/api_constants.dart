// lib/app/constants/api_constants.dart

class ApiConstants {
  static const String baseUrl = "https://api.helpmespeak.app";

  // ==========================================
  // Auth Endpoints
  // ==========================================
  static const String login = "/api/auth/login/";
  static const String signup = "/api/auth/register/";
  static const String otpVerify = "/api/auth/otp/verify/";
  static const String forgotPassword = "/api/auth/password/forgot/";
  static const String resetPasswordVerify = "/api/auth/password/reset/verify/";
  static const String resetPasswordConfirm = "/api/auth/password/reset/confirm/";

  // ==========================================
  // Social Auth Endpoints
  // ==========================================
  static const String appleLogin = "/api/dj-rest-auth/apple/";
  static const String googleLogin = "/api/auth/google/id-token/";

  // ==========================================
  // Chat & Translate Endpoints
  // ==========================================
  static const String chatbot = "/api/chat/";
  static const String translate = "/tts/translatetts/";

  // ==========================================
  // Phrasebook Endpoints
  // ==========================================
  static const String categories = "/api/category-names/";
  static const String phrases = "/api/phrases/";

  // ==========================================
  // Profile Endpoints
  // ==========================================
  static const String profile = "/api/auth/me/";
  static const String deleteProfile = "/api/profile/delete/";  // NEW

  // ==========================================
  // Payment & Subscription Endpoints
  // ==========================================
  static const String paymentPlans = "/api/payment/plans/";
  static const String iapValidate = "/api/payment/iap/validate/";
  static const String subscriptionManage = "/api/payment/subscription/manage/";

  // ==========================================
  // Helper Methods
  // ==========================================

  /// Get full URL for any endpoint
  static String getFullUrl(String endpoint) {
    return baseUrl + endpoint;
  }

  /// Get payment plans URL
  static String get paymentPlansUrl => baseUrl + paymentPlans;

  /// Get IAP validation URL
  static String get iapValidateUrl => baseUrl + iapValidate;

  /// Get subscription management URL
  static String get subscriptionManageUrl => baseUrl + subscriptionManage;

  /// Get delete profile URL
  static String get deleteProfileUrl => baseUrl + deleteProfile;
}