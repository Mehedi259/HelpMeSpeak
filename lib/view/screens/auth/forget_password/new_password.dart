import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/password_field.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

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
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (!_isPasswordStrong(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must contain uppercase, lowercase, and numbers')),
      );
      return;
    }

    /// ✅ Show success popup instead of direct navigation
    _showSuccessPopup();
  }

  void _handleBack() {
    context.pop();
  }

  bool _isPasswordStrong(String password) {
    return password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  /// Success Popup
  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // must click button
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFF048BC2), // blue background
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
                  /// lock/star image
                  SizedBox(
                    width: 122,
                    height: 122,
                    child: Image.asset(
                      "assets/images/starlock.png", // 🔑 replace with your image
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// text
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

                  /// continue button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // close dialog
                      context.go(AppRoutes.signin); // go to sign in
                    },
                    child: Container(
                      width: 167,
                      height: 33,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C7AC0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Color(0x17000000),
                            blurRadius: 12,
                            offset: Offset(0, 12),
                          ),
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 16,
                            offset: Offset(0, 27),
                          ),
                          BoxShadow(
                            color: Color(0x03000000),
                            blurRadius: 19,
                            offset: Offset(0, 48),
                          ),
                        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/authbg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: _handleBack,
                      ),
                      const Expanded(
                        child: Text(
                          'Create New Password',
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
                          const SizedBox(height: 40),
                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: 'New Password...',
                            controller: _newPasswordController,
                            isVisible: _isNewPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
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
                          CustomButton(
                            text: 'Reset Password',
                            onPressed: _handleResetPassword,
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
