import '../../app/constants/api_constants.dart';
import 'api_service.dart';

class ForgetPasswordService {
  /// Send forgot password email
  static Future<Map<String, dynamic>> sendForgotPasswordEmail(
      String email) async {
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