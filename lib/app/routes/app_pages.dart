// lib/app/routes/app_pages.dart (Updated with subscription check)

import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

import '../../controllers/subscription_controller.dart';
import '../../view/screens/auth/forget_password/forget_password.dart';
import '../../view/screens/auth/forget_password/new_password.dart';
import '../../view/screens/auth/forget_password/otp_screen.dart';
import '../../view/screens/auth/signin_signup/otp_screen.dart';
import '../../view/screens/auth/signin_signup/signin_signup.dart';
import '../../view/screens/onbording/splash_screen.dart';
import '../../view/screens/onbording/logo_screen.dart';
import '../../view/screens/onbording/onbording_screen1.dart';
import '../../view/screens/onbording/onbording_screen2.dart';
import '../../view/screens/onbording/onbording_screen3.dart';
import '../../view/screens/onbording/onbording_screen4.dart';
import '../../view/screens/auth/signin_signup/sign_in.dart';
import '../../view/screens/auth/signin_signup/sign_up.dart';
import '../../view/screens/user_flow/home/home.dart';
import '../../view/screens/user_flow/home/subscription_popup.dart';
import '../../view/screens/user_flow/phrasebook/phrasebook.dart';
import '../../view/screens/user_flow/user_profile/edit_profile.dart';
import '../../view/screens/user_flow/user_profile/privacy_policy.dart';
import '../../view/screens/user_flow/user_profile/profile.dart';
import '../../view/screens/user_flow/talk_with_ai/ai_chat_bot.dart';
import '../../view/screens/user_flow/instant_translation/instant_translation.dart';

import 'app_routes.dart';

class AppPages {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      // Check if user is trying to access subscription screen
      if (state.matchedLocation == AppRoutes.subscription) {
        // Initialize subscription controller if not already done
        final controller = Get.isRegistered<SubscriptionController>()
            ? Get.find<SubscriptionController>()
            : Get.put(SubscriptionController());

        // Check subscription status
        await controller.checkSubscriptionStatus();

        // If user is paid, redirect to home
        if (controller.isPaidUser.value) {
          return AppRoutes.home;
        }
      }

      return null; // Allow navigation
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.logo,
        builder: (context, state) => const LogoScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding1,
        builder: (context, state) => const OnboardingScreen1(),
      ),
      GoRoute(
        path: AppRoutes.onboarding2,
        builder: (context, state) => const OnboardingScreen2(),
      ),
      GoRoute(
        path: AppRoutes.onboarding3,
        builder: (context, state) => const OnboardingScreen3(),
      ),
      GoRoute(
        path: AppRoutes.onboarding4,
        builder: (context, state) => const OnboardingScreen4(),
      ),
      GoRoute(
        path: AppRoutes.signin,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.authOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?["email"] ?? "";
          return AuthOtpScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] ?? '';
          return OtpScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.newpassword,
        builder: (context, state) {
          return const CreateNewPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiChatBot,
        builder: (context, state) => const AiChatBotScreen(),
      ),
      GoRoute(
        path: AppRoutes.instantTranslation,
        builder: (context, state) => InstantTranslationScreen(),
      ),
      GoRoute(
        path: AppRoutes.phrasebook,
        builder: (context, state) => const PhrasebookScreen(),
      ),
      GoRoute(
        path: AppRoutes.singInsignUp,
        builder: (context, state) => const SignInSignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
}