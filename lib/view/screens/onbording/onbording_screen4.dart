// lib/view/screens/onboarding/onboarding_screen4.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../gen/assets.gen.dart';
import '../../widgets/button.dart';

/// OnboardingScreen4
/// Fourth onboarding screen: Phrasebook feature introduction.
class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fullscreen layered UI
      body: Stack(
        children: [
          /// Background image covering full screen
          Positioned.fill(
            child: Assets.images.onbording123.image(
              fit: BoxFit.cover,
            ),
          ),

          /// Foreground content inside SafeArea
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Top-right Skip button
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

                  const SizedBox(height: 30),

                  /// Logo image
                  Assets.images.onbordinglogo4.image(
                    width: 300,
                    height: 300,
                  ),

                  const SizedBox(height: 60),

                  /// Title text
                  const Text(
                    " Phrasebook",
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

                  /// Subtitle text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Store and categorize your favorite phrases, and add your own for quick reference",
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

                  const SizedBox(height: 80),

                  /// Bottom pagination + Next button
                  Column(
                    children: [
                      Assets.icons.onb4.image(
                        width: 51,
                        height: 7,
                      ),
                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: CustomButton(
                          text: "Next",
                          onPressed: () {
                            context.go(AppRoutes.singInsignUp);
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
