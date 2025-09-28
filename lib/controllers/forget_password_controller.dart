import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../app/routes/app_routes.dart';
import '../data/services/forget_password_service.dart';

class ForgetPasswordController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;

  /// Send forgot password email
  Future<void> sendForgotPasswordEmail(
      BuildContext context, String emailAddress) async {
    if (emailAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      isLoading.value = true;
      email.value = emailAddress;

      final res = await ForgetPasswordService.sendForgotPasswordEmail(emailAddress);

      if (res['success'] == true || res['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res['message'] ?? 'Reset code sent to your email')),
        );

        // Navigate to OTP screen with email
        context.go(AppRoutes.otp, extra: {'email': emailAddress});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res['error'] ?? 'Failed to send reset code')),
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
}