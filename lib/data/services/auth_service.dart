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
}
