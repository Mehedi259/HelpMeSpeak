import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/password_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle signup button press
  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    context.go(AppRoutes.signin);
  }

  /// Navigate back to sign in
  void _handleSignIn() {
    context.go(AppRoutes.signin);
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
                        onPressed: () {
                          context.go(AppRoutes.singInsignUp);
                        }
                      ),
                      const Expanded(
                        child: Text(
                          'Sign up',
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
                          InputField(
                            icon: Icons.person_outline,
                            hint: 'Name...',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 20),

                          InputField(
                            icon: Icons.email_outlined,
                            hint: 'Email...',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

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
                          const SizedBox(height: 20),

                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: 'Confirm Password...',
                            controller: _confirmPasswordController,
                            isVisible: _isConfirmPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 40),

                          // Sign up button
                          CustomButton(
                            text: 'Sign up',
                            onPressed: _handleSignUp,
                          ),
                          const SizedBox(height: 20),

                          // Sign in link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleSignIn,
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
