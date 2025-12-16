// lib/utils/storage_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _genderKey = "user_gender";
  static const String _dateOfBirthKey = "user_date_of_birth";
  static const String _subscriptionStatusKey = "subscription_status";
  static const String _isPaidUserKey = "is_paid_user";

  /// Save Access Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final safe = token.trim();
    await prefs.setString(_tokenKey, safe);
    print("💾 Access token saved");
  }

  /// Get Access Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token?.trim();
  }

  /// Save Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    final safe = refreshToken.trim();
    await prefs.setString(_refreshTokenKey, safe);
    print("💾 Refresh token saved");
  }

  /// Get Refresh Token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_refreshTokenKey);
    return token?.trim();
  }

  /// Save Both Tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Clear Access Token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print("🗑️ Access token cleared");
  }

  /// Clear Refresh Token
  static Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
    print("🗑️ Refresh token cleared");
  }

  /// Clear All Tokens (Logout)
  static Future<void> clearAllTokens() async {
    await clearToken();
    await clearRefreshToken();
    print("🗑️ All tokens cleared");
  }

  // ==========================================
  // Gender & Date of Birth Methods
  // ==========================================

  /// Save Gender
  static Future<void> saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender);
    print("💾 Gender saved: $gender");
  }

  /// Get Gender
  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_genderKey);
  }

  /// Save Date of Birth
  static Future<void> saveDateOfBirth(String dateOfBirth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateOfBirthKey, dateOfBirth);
    print("💾 Date of Birth saved: $dateOfBirth");
  }

  /// Get Date of Birth
  static Future<String?> getDateOfBirth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateOfBirthKey);
  }

  /// Clear Gender
  static Future<void> clearGender() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_genderKey);
    print("🗑️ Gender cleared");
  }

  /// Clear Date of Birth
  static Future<void> clearDateOfBirth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dateOfBirthKey);
    print("🗑️ Date of Birth cleared");
  }

  // ==========================================
  // NEW: Subscription Status Methods
  // ==========================================

  /// Save Subscription Status
  static Future<void> saveSubscriptionStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionStatusKey, status);
    print("💾 Subscription status saved: $status");
  }

  /// Get Subscription Status
  static Future<String?> getSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_subscriptionStatusKey);
  }

  /// Save Paid User Status
  static Future<void> saveIsPaidUser(bool isPaid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPaidUserKey, isPaid);
    print("💾 Paid user status saved: $isPaid");
  }

  /// Get Paid User Status
  static Future<bool> getIsPaidUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPaidUserKey) ?? false;
  }

  /// Clear Subscription Data
  static Future<void> clearSubscriptionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionStatusKey);
    await prefs.remove(_isPaidUserKey);
    print("🗑️ Subscription data cleared");
  }

  /// Clear All User Data (including gender, DOB, and subscription)
  static Future<void> clearAllUserData() async {
    await clearAllTokens();
    await clearGender();
    await clearDateOfBirth();
    await clearSubscriptionData();
    print("🗑️ All user data cleared");
  }
}