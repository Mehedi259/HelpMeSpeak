import 'package:HelpMeSpeak/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/password_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ===== Handle Email/Password Sign In =====
  void _handleSignIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    final authController = Get.find<AuthController>();
    authController.login(context, email, password, rememberMe: _rememberMe);
  }

  /// ===== Handle Forgot Password =====
  void _handleForgotPassword() {
    context.go(AppRoutes.forgetPassword);
  }

  /// ===== Handle Google Sign-In - UPDATED =====
  void _handleGoogleSignIn() async {
    final authController = Get.find<AuthController>();

    try {
      print("🔵 User tapped Google Sign-In button");

      // Call the controller method directly
      // No need to show loading dialog here as controller manages isLoading
      await authController.googleLogin(context);

    } catch (e) {
      print("❌ Error in _handleGoogleSignIn: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In failed: ${e.toString()}")),
        );
      }
    }
  }


  /// ===== Handle Apple Sign-In =====
  void _handleAppleSignIn() async {
    try {
      // Check if Apple Sign In is available
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Apple Sign In is not available on this device"),
          ),
        );
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.helpmespeak',
          redirectUri: Uri.parse(
            'https://api.helpmespeak.app/api/dj-rest-auth/apple/callback/',
          ),
        ),
      );

      final idToken = credential.identityToken;

      if (idToken == null || idToken.isEmpty) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close loading dialog
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to retrieve Apple token")),
        );
        return;
      }

      // Get user info
      final userIdentifier = credential.userIdentifier ?? "";
      final email = credential.email ?? "";
      final givenName = credential.givenName ?? "";
      final familyName = credential.familyName ?? "";

      print("✅ Apple Sign-in successful");
      print("User ID: $userIdentifier");
      print("Email: $email");
      print("Given Name: $givenName");
      print("Family Name: $familyName");

      // If email is empty (repeat sign-in), use userIdentifier
      final finalEmail = email.isNotEmpty ? email : userIdentifier;

      final authController = Get.find<AuthController>();

      await authController.appleLogin(
        context,
        idToken: idToken,
        email: finalEmail,
        givenName: givenName,
        familyName: familyName,
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog
      }

      String errorMessage = "Apple Sign-in failed";

      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          errorMessage = "Sign in was canceled";
          break;
        case AuthorizationErrorCode.failed:
          errorMessage = "Sign in failed";
          break;
        case AuthorizationErrorCode.invalidResponse:
          errorMessage = "Invalid response from Apple";
          break;
        case AuthorizationErrorCode.notHandled:
          errorMessage = "Sign in was not handled";
          break;
        case AuthorizationErrorCode.notInteractive:
          errorMessage = "Sign in is not interactive";
          break;
        case AuthorizationErrorCode.unknown:
          errorMessage = "Unknown error occurred";
          break;
        default:
          errorMessage = "An error occurred";
      }

      print("❌ Apple Sign-in error: ${e.code} - ${e.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog
      }

      print("❌ Unexpected error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/authbg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header with Back Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => context.go(AppRoutes.singInsignUp),
                      ),
                      const Expanded(
                        child: Text(
                          "Sign in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance the back button
                    ],
                  ),
                ),

                // Main Content Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 60),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),

                          // Email Input Field
                          InputField(
                            icon: Icons.email_outlined,
                            hint: "Email...",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Password Input Field
                          PasswordField(
                            icon: Icons.lock_outline,
                            hint: "Password...",
                            controller: _passwordController,
                            isVisible: _isPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign In Button
                          Obx(() {
                            return CustomButton(
                              text: "Sign In",
                              isLoading: authController.isLoading.value,
                              onPressed: _handleSignIn,
                            );
                          }),
                          const SizedBox(height: 30),

                          // Divider with "Or" text
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Or",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
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
                          const SizedBox(height: 20),

                          // "Sign in with" text
                          Center(
                            child: Text(
                              "Sign in with",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Social Sign-In Buttons (Google & Apple)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Sign-In Button
                              GestureDetector(
                                onTap: _handleGoogleSignIn,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/icons/google.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Apple Sign-In Button
                              GestureDetector(
                                onTap: _handleAppleSignIn,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.apple,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
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