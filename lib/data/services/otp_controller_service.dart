import '../../app/constants/api_constants.dart';
import 'api_service.dart';

class OtpService {
  /// Verify OTP for password reset
  static Future<Map<String, dynamic>> verifyResetOtp(
      String email, String otp) async {
    try {
      final response = await ApiService.postRequest(
        ApiConstants.resetPasswordVerify,
        body: {
          "email": email,
          "otp": otp,
        },
      );

      if (response is List && response.isNotEmpty) {
        return response[0];
      } else if (response is Map<String, dynamic>) {
        return response;
      } else {
        return {
          "success": false,
          "error": "Unexpected response format"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": e.toString()
      };
    }
  }

  /// Resend OTP code
  static Future<Map<String, dynamic>> resendOtp(String email) async {
    try {
      final response = await ApiService.postRequest(
        ApiConstants.forgotPassword,
        body: {
          "email": email,
        },
      );

      if (response is List && response.isNotEmpty) {
        return response[0];
      } else if (response is Map<String, dynamic>) {
        return response;
      } else {
        return {
          "success": false,
          "error": "Unexpected response format"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": e.toString()
      };
    }
  }
}