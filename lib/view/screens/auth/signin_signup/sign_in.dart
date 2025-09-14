import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/password_field.dart';
import '../../../../gen/assets.gen.dart'; // FlutterGen Assets

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Sign in button logic
  void _handleSignIn() {
    context.go(AppRoutes.subscription);
  }

  void _handleSignUp() => context.go(AppRoutes.signup);

  void _handleForgotPassword() {
      context.go(AppRoutes.forgetPassword);
  }

  void _handleGoogleSignIn() {
    context.go(AppRoutes.subscription);
  }

  void _handleFacebookSignIn() {
    context.go(AppRoutes.subscription);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/authbg.png',
              fit: BoxFit.cover,
            ),
          ),
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
                        onPressed: () {
                          context.go(AppRoutes.singInsignUp);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Sign in',
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

                // Form container
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

                          // Email
                          InputField(
                            icon: Icons.email_outlined,
                            hint: 'Email...',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Password
                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: 'Password...',
                            controller: _passwordController,
                            isVisible: _isPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _handleForgotPassword,
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF42A5F5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Sign in button
                          CustomButton(
                            text: 'Sign In',
                            onPressed: _handleSignIn,
                          ),
                          const SizedBox(height: 24),

                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Sign in with',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Social login buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google
                              GestureDetector(
                                onTap: _handleGoogleSignIn,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Assets.icons.google.image(
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Facebook
                              GestureDetector(
                                onTap: _handleFacebookSignIn,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.facebook,
                                    color: Color(0xFF1877F2),
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleSignUp,
                                child: const Text(
                                  'Sign up here',
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
