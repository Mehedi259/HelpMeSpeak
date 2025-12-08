// lib/view/screens/onbording/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../utils/storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Check if user is logged in
  Future<void> _checkLoginStatus() async {
    // 2 seconds delay for splash display
    await Future.delayed(const Duration(seconds: 2));

    // Check if token exists
    final token = await StorageHelper.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in → Go to Home
      print("✅ Token found: Navigating to Home");
      context.go(AppRoutes.home);
    } else {
      // User not logged in → Go to Logo/Onboarding
      print("❌ No token: Navigating to Logo");
      context.go(AppRoutes.logo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF048BC2),
      body: Center(
        child: Text(
          "HelpMeSpeak",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}