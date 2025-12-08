// lib/data/services/auth_service.dart

import '../../app/constants/api_constants.dart';
import 'api_service.dart';

class AuthService {
  /// ===== Login =====
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.postRequest(
      ApiConstants.login,
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response is List && response.isNotEmpty) {
      return response[0];
    } else if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Unexpected login response: $response");
    }
  }

  /// ===== Register =====
  static Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    final response = await ApiService.postRequest(
      ApiConstants.signup,
      body: body,
    );

    if (response is List && response.isNotEmpty) {
      return response[0];
    } else if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Unexpected register response: $response");
    }
  }

  /// ===== Verify OTP =====
  static Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> body) async {
    final response = await ApiService.postRequest(
      ApiConstants.otpVerify,
      body: body,
    );

    if (response is List && response.isNotEmpty) {
      return response[0];
    } else if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Unexpected OTP response: $response");
    }
  }

  /// ===== Apple Login =====
  static Future<Map<String, dynamic>> appleLogin(Map<String, dynamic> body) async {
    final firstName = body["first_name"] ?? "";
    final lastName = body["last_name"] ?? "";
    final fullName = "$firstName $lastName".trim();

    final requestBody = {
      "id_token": body["id_token"],
      "full_name": fullName.isNotEmpty ? fullName : null,
      "email": body["email"]?.toString().isNotEmpty == true ? body["email"] : null,
    };

    requestBody.removeWhere((key, value) => value == null);

    print("🍎 Apple Login Request Body: $requestBody");

    final response = await ApiService.postRequest(
      ApiConstants.appleLogin,
      body: requestBody,
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Unexpected Apple login response: $response");
    }
  }

  /// ===== Google Login ===== ✅ ONLY EMAIL - NO ID TOKEN
  static Future<Map<String, dynamic>> googleLogin(String email) async {
    final requestBody = {
      "email": email,
    };

    print("🔵 ===== GOOGLE LOGIN API CALL =====");
    print("🔵 Endpoint: ${ApiConstants.baseUrl}${ApiConstants.googleLogin}");
    print("🔵 Request Body: $requestBody");

    try {
      final response = await ApiService.postRequest(
        ApiConstants.googleLogin,
        body: requestBody,
      );

      print("📥 Response Type: ${response.runtimeType}");
      print("📥 Response: $response");

      if (response is Map<String, dynamic>) {
        return response;
      } else if (response is List && response.isNotEmpty) {
        print("⚠️ Response is List, taking first item");
        return response[0] as Map<String, dynamic>;
      } else {
        print("❌ Unexpected response format");
        throw Exception("Unexpected Google login response: $response");
      }
    } catch (e) {
      print("❌ Google Login API Error: $e");
      rethrow;
    }
  }
}