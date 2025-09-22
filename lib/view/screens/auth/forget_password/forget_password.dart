import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Text controller
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controller to avoid memory leaks
    _emailController.dispose();
    super.dispose();
  }

  /// Handle send code button press
  void _handleSendCode() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // Add your forgot password logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset code sent to $email')),
    );

    // Navigate to verification screen or back to sign in
     context.go(AppRoutes.otp);
  }

  /// Navigate back to sign in
  void _handleBackToSignIn() {
    context.go(AppRoutes.signin);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
                        onPressed: _handleBackToSignIn,
                      ),
                      const Expanded(
                        child: Text(
                          'Forgot Password?',
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
                          const Text(
                            'Provide the email linked to your account. We\'ll send a password reset code to your inbox.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Email field
                          InputField(
                            icon: Icons.email_outlined,
                            hint: 'my****@gmail.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 60),

                          // Send code button
                          CustomButton(
                            text: 'Send Code',
                            onPressed: _handleSendCode,
                          ),
                          const SizedBox(height: 30),

                          // Back to sign in link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Remember your password? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleBackToSignIn,
                                child: const Text(
                                  'Sign in here',
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