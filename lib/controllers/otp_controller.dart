import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../app/routes/app_routes.dart';
import '../data/services/otp_controller_service.dart';


class OtpController extends GetxController {
  var isLoading = false.obs;
  var resetToken = ''.obs;

  /// Verify OTP for password reset
  Future<void> verifyResetOtp(
      BuildContext context, String email, String otp) async {
    if (email.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP code')),
      );
      return;
    }

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP must be 6 digits')),
      );
      return;
    }

    try {
      isLoading.value = true;

      final res = await OtpService.verifyResetOtp(email, otp);

      if (res['reset_token'] != null) {
        resetToken.value = res['reset_token'].toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res['message'] ?? 'OTP verified successfully')),
        );

        // Navigate to new password screen with reset token
        context.go(AppRoutes.newpassword,
            extra: {'reset_token': resetToken.value});
      } else if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'OTP verified')),
        );
        context.go(AppRoutes.newpassword);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'] ?? 'Invalid OTP code')),
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

  /// Resend OTP
  Future<void> resendOtp(BuildContext context, String email) async {
    try {
      isLoading.value = true;

      final res = await OtpService.resendOtp(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Code resent to your email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      isLoading.value = false;
    }
  }
}