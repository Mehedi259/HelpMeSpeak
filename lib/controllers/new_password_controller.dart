import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../app/routes/app_routes.dart';
import '../data/services/new_password_service.dart';

class NewPasswordController extends GetxController {
  var isLoading = false.obs;

  /// Reset password with new password
  Future<void> resetPassword(
      BuildContext context,
      String resetToken,
      String newPassword,
      String confirmPassword,
      ) async {
    // Validation
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (!_isPasswordStrong(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password must contain uppercase, lowercase, and numbers')),
      );
      return;
    }

    try {
      isLoading.value = true;

      final res = await NewPasswordService.resetPassword(
        resetToken,
        newPassword,
        confirmPassword,
      );

      if (res['success'] == true || res['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text(res['message'] ?? 'Password reset successfully')),
        );

        // Show success popup and navigate to sign in
        _showSuccessPopup(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res['error'] ?? 'Failed to reset password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Password strength validation
  bool _isPasswordStrong(String password) {
    return password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  /// Success popup dialog
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFF048BC2),
          body: Center(
            child: Container(
              width: 297,
              height: 314,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 122,
                    height: 122,
                    child: Image.asset(
                      "assets/images/starlock.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Your Password has been reset",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF604E4E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Successfully!",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xDB000000),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.signin);
                    },
                    child: Container(
                      width: 167,
                      height: 33,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C7AC0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}