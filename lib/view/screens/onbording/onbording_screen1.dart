// lib/view/screens/onboarding/onboarding_screen1.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../gen/assets.gen.dart';
import '../../widgets/button.dart';

/// OnboardingScreen1
/// First onboarding screen with background, heading text and navigation button.
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Fullscreen background image
          Positioned.fill(
            child: Assets.images.onbording1.image(
              fit: BoxFit.cover,
            ),
          ),

          /// Foreground content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  /// Heading section with styled text
                  Container(
                    width: 326,
                    height: 300,
                    alignment: Alignment.topCenter,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Pontano Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 40,
                          height: 59 / 40,
                          letterSpacing: 0.5,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: 'Learn ',
                            style: TextStyle(color: Color(0xFF2196F3)),
                          ),
                          TextSpan(text: 'languages\n'),
                          TextSpan(text: 'with real-time\n'),
                          TextSpan(text: 'translations &\n'),
                          TextSpan(
                            text: 'AI Chat',
                            style: TextStyle(color: Color(0xFF2196F3)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 250),

                  /// Bottom navigation indicators + Next button
                  Column(
                    children: [
                      Assets.icons.onb1.image(
                        width: 51,
                        height: 7,
                      ),
                      const SizedBox(height: 40),

                      CustomButton(
                        text: "Next",
                        onPressed: () {
                          context.go(AppRoutes.onboarding2);
                        },
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
