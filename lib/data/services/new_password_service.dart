import '../../app/constants/api_constants.dart';
import 'api_service.dart';

class NewPasswordService {
  /// Reset password with new password
  static Future<Map<String, dynamic>> resetPassword(
      String resetToken,
      String newPassword,
      String confirmPassword,
      ) async {
    try {
      final response = await ApiService.postRequest(
        ApiConstants.resetPasswordConfirm,
        body: {
          "reset_token": resetToken,
          "new_password": newPassword,
          "new_password_confirm": confirmPassword,
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