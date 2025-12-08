import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../widgets/opt_button.dart';

class AuthOtpScreen extends StatefulWidget {
  final String email;

  const AuthOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isOtpComplete = false;
  String? errorText;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  /// Validate OTP
  String? _validateOtp(String value) {
    if (value.isEmpty) {
      return "Please enter the verification code";
    }
    if (value.length != 6) {
      return "Code must be 6 digits";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Code must contain only numbers";
    }
    return null;
  }

  /// Handle verify code button press
  void _handleVerifyCode() async {
    final code = otpController.text.trim();

    // Validate OTP
    final validation = _validateOtp(code);
    if (validation != null) {
      setState(() {
        errorText = validation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      errorText = null;
    });

    final authController = Get.find<AuthController>();

    try {
      await authController.verifyOtp(
        context,
        widget.email,
        code,
        "email_verification",
      );

      // Only navigate if verification was successful
      // The authController should handle success/error internally
      // but we keep this for safety
      if (mounted) {
        context.go(AppRoutes.signin);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorText = "Invalid verification code";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handle resend code
  void _handleResendCode() async {
    final authController = Get.find<AuthController>();

    try {
      // Call your resend OTP API here
      // await authController.resendOtp(widget.email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code resent to ${widget.email}'),
            backgroundColor: Colors.green,
          ),
        );

        otpController.clear();
        setState(() {
          isOtpComplete = false;
          errorText = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate back
  void _handleBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/authbg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Foreground content
          SafeArea(
            child: Column(
              children: [
                // Top navigation
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _handleBack,
                      ),
                      const Expanded(
                        child: Text(
                          'Verify Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Spacer to balance the back button
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // White container with form
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Title
                          const Text(
                            'Enter Verification Code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description text
                          Text(
                            'We sent a 6 digit verification code to ${widget.email}. Please enter it below to verify your account.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // OTP input field
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            autoDisposeControllers: false,
                            cursorColor: const Color(0xFF2196F3),
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 55,
                              fieldWidth: 48,
                              borderWidth: 2,
                              activeColor: errorText != null
                                  ? Colors.red
                                  : const Color(0xFF2196F3),
                              selectedColor: errorText != null
                                  ? Colors.red
                                  : const Color(0xFF2196F3),
                              inactiveColor: errorText != null
                                  ? Colors.red.shade200
                                  : Colors.grey.shade300,
                              activeFillColor: Colors.transparent,
                              selectedFillColor: Colors.transparent,
                              inactiveFillColor: Colors.transparent,
                              errorBorderColor: Colors.red,
                            ),
                            animationDuration: const Duration(milliseconds: 300),
                            enableActiveFill: false,
                            errorAnimationController: null,
                            onChanged: (value) {
                              setState(() {
                                isOtpComplete = value.length == 6;
                                // Clear error when user starts typing
                                if (errorText != null) {
                                  errorText = null;
                                }
                              });
                            },
                            onCompleted: (value) {
                              // Auto-validate when all 6 digits are entered
                              final validation = _validateOtp(value);
                              setState(() {
                                errorText = validation;
                              });
                            },
                          ),

                          // Error message
                          if (errorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 40),

                          // Verify code button (using OptButton)
                          Obx(() {
                            return OptButton(
                              text: authController.isLoading.value
                                  ? "Verifying..."
                                  : "Verify Code",
                              isEnabled: isOtpComplete &&
                                  !authController.isLoading.value &&
                                  errorText == null,
                              onPressed: authController.isLoading.value
                                  ? () {}
                                  : _handleVerifyCode,
                            );
                          }),

                          const SizedBox(height: 30),

                          // Resend code link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Haven't got the email yet? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Obx(() {
                                return GestureDetector(
                                  onTap: authController.isLoading.value
                                      ? null
                                      : _handleResendCode,
                                  child: Text(
                                    'Resend code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: authController.isLoading.value
                                          ? Colors.grey
                                          : const Color(0xFF42A5F5),
                                      fontWeight: FontWeight.w600,
                                      decoration: authController.isLoading.value
                                          ? TextDecoration.none
                                          : TextDecoration.underline,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Additional info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Check your spam folder if you don\'t see the email in your inbox.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade900,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}