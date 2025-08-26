// lib/view/screens/onbording/onbording_screen2.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../gen/assets.gen.dart';
import '../../widgets/button.dart'; // custom button import

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Fullscreen background
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.onbording123.image(
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                //  AppBar skip button
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRoutes.singInsignUp);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xE52F2B2B), // #2F2B2BE5
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                //  Logo Image
                Assets.images.onbordinglogo2.image(
                  width: 300,
                  height: 300,
                ),

                const SizedBox(height: 80),

                //  Title text
                const Text(
                  "AI Chat Practice",
                  style: TextStyle(
                    fontFamily: "Pontano Sans",
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    height: 1.0,
                    letterSpacing: 0.5,
                    color: Color(0xF5000000), // #000000F5
                  ),
                ),

                const SizedBox(height: 16),

                //  Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Engage in realistic conversations with our AI to practice speaking and improve your skills",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      height: 1.0,
                      color: Color(0xE5000000), // #000000E5
                    ),
                  ),
                ),

                const Spacer(),

                //  Pagination icon
                Assets.icons.onb3.image(
                  width: 51,
                  height: 7,
                ),

                const SizedBox(height: 40),

                //  Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      context.go(AppRoutes.onboarding4);
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
