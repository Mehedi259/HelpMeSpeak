// lib/view/screens/onbording/onbording_screen1.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../gen/assets.gen.dart';
import '../../widgets/button.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.onbording1.image(
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  Container(
                    width: 326,
                    height: 300,
                    alignment: Alignment.centerLeft,
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

                  const Spacer(flex: 1),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
