// lib/view/screens/onbording/logo_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../gen/assets.gen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    // 2 seconds delay, then navigate to Onboarding1
    Future.delayed(const Duration(seconds: 2), () {
      context.go(AppRoutes.onboarding1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.logo.image(
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'HelpMeSpeak',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F85AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
