// lib/view/screens/auth/sign_in_sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/button.dart';

/// SignInSignUpScreen
/// --------------------
/// This screen acts as the entry point for authentication.
/// It allows users to either sign up with email, Google,
/// or navigate to the sign-in flow if they already have an account.
/// Design strictly follows the provided Figma specification.
class SignInSignUpScreen extends StatelessWidget {
  const SignInSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Decorative illustration
              Center(
                child: Assets.images.helpmespeak.image(
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),

              /// Tagline / description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Text(
                  "HelpMeSpeak is an interactive language learning app with real-time translations and AI-powered practice",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xA6000000),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Primary CTA - Sign Up with Email
              CustomButton(
                text: "Sign Up With Email",
                onPressed: () {
                  context.go(AppRoutes.signup);
                },
              ),

              const SizedBox(height: 10),

              /// OR Separator
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "-- or --",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Already have an account? Sign-in
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.signin);
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          color: Color(0xFF888888),
                        ),
                      ),
                      TextSpan(
                        text: "Sign-in",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          color: Color(0xFF048BC2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
