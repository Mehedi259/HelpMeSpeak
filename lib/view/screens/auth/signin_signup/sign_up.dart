import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/password_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Error messages for each field
  String? _usernameError;
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return "Username is required";
    }
    if (value.length < 3) {
      return "Username must be at least 3 characters";
    }
    if (value.length > 20) {
      return "Username must be less than 20 characters";
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return "Username can only contain letters, numbers, and underscores";
    }
    return null;
  }

  String? _validateFullName(String value) {
    if (value.isEmpty) {
      return "Full name is required";
    }
    if (value.length < 2) {
      return "Full name must be at least 2 characters";
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return "Full name can only contain letters and spaces";
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }

  String? _validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  bool _validateAllFields() {
    setState(() {
      _usernameError = _validateUsername(_usernameController.text.trim());
      _fullNameError = _validateFullName(_fullNameController.text.trim());
      _emailError = _validateEmail(_emailController.text.trim());
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
    });

    return _usernameError == null &&
        _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _handleSignUp() {
    if (!_validateAllFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fix all errors before continuing"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authController = Get.find<AuthController>();
    authController.register(
      context,
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _confirmPasswordController.text,
      _fullNameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/authbg.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 20),
                        onPressed: () => context.go(AppRoutes.singInsignUp),
                      ),
                      const Expanded(
                        child: Text(
                          "Sign up",
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Username Field
                          InputField(
                            icon: Icons.account_circle_outlined,
                            hint: "Username...",
                            controller: _usernameController,
                            errorText: _usernameError,
                            onChanged: (value) {
                              if (_usernameError != null) {
                                setState(() {
                                  _usernameError = _validateUsername(value.trim());
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Full Name Field
                          InputField(
                            icon: Icons.person_outline,
                            hint: "Full Name...",
                            controller: _fullNameController,
                            errorText: _fullNameError,
                            onChanged: (value) {
                              if (_fullNameError != null) {
                                setState(() {
                                  _fullNameError = _validateFullName(value.trim());
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Email Field
                          InputField(
                            icon: Icons.email_outlined,
                            hint: "Email...",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: (value) {
                              if (_emailError != null) {
                                setState(() {
                                  _emailError = _validateEmail(value.trim());
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Password Field
                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: "Password...",
                            controller: _passwordController,
                            isVisible: _isPasswordVisible,
                            errorText: _passwordError,
                            onVisibilityToggle: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            onChanged: (value) {
                              if (_passwordError != null) {
                                setState(() {
                                  _passwordError = _validatePassword(value);
                                });
                              }
                              // Also revalidate confirm password if it has been filled
                              if (_confirmPasswordController.text.isNotEmpty &&
                                  _confirmPasswordError != null) {
                                setState(() {
                                  _confirmPasswordError = _validateConfirmPassword(
                                    _confirmPasswordController.text,
                                    value,
                                  );
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Confirm Password Field
                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: "Confirm Password...",
                            controller: _confirmPasswordController,
                            isVisible: _isConfirmPasswordVisible,
                            errorText: _confirmPasswordError,
                            onVisibilityToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                            onChanged: (value) {
                              if (_confirmPasswordError != null) {
                                setState(() {
                                  _confirmPasswordError = _validateConfirmPassword(
                                    value,
                                    _passwordController.text,
                                  );
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 40),

                          Obx(() {
                            return CustomButton(
                              text: authController.isLoading.value
                                  ? "Signing up..."
                                  : "Sign up",
                              onPressed: authController.isLoading.value
                                  ? () {}
                                  : _handleSignUp,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}