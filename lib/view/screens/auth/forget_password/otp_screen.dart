import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../../controllers/otp_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../widgets/opt_button.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpTextController = TextEditingController();
  final otpController = Get.put(OtpController());
  bool isOtpComplete = false;

  @override
  void dispose() {
    otpTextController.dispose();
    super.dispose();
  }

  /// Handle verify code button press
  void _handleVerifyCode() {
    if (isOtpComplete) {
      final code = otpTextController.text;
      otpController.verifyResetOtp(context, widget.email, code);
    }
  }

  /// Handle resend code
  void _handleResendCode() {
    otpController.resendOtp(context, widget.email);
    otpTextController.clear();
    setState(() {
      isOtpComplete = false;
    });
  }

  /// Navigate back
  void _handleBack() {
    context.go(AppRoutes.forgetPassword);
  }

  @override
  Widget build(BuildContext context) {
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
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // White container with form
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 60),
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

                          // Description text
                          Text(
                            'We sent a reset link to ${widget.email} enter 6 digit code that mentioned in the email',
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
                            controller: otpTextController,
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
                              fieldHeight: 50,
                              fieldWidth: 45,
                              borderWidth: 2,
                              activeColor: const Color(0xFF2196F3),
                              selectedColor: const Color(0xFF2196F3),
                              inactiveColor: Colors.grey.shade300,
                              activeFillColor: Colors.transparent,
                              selectedFillColor: Colors.transparent,
                              inactiveFillColor: Colors.transparent,
                            ),
                            animationDuration:
                            const Duration(milliseconds: 300),
                            enableActiveFill: false,
                            onChanged: (value) {
                              setState(() {
                                isOtpComplete = value.length == 6;
                              });
                            },
                          ),

                          const SizedBox(height: 40),

                          // Verify code button
                          OptButton(
                            text: "Verify code",
                            isEnabled: isOtpComplete,
                            onPressed: _handleVerifyCode,
                          ),

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
                              GestureDetector(
                                onTap: _handleResendCode,
                                child: const Text(
                                  'Resend code',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF42A5F5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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