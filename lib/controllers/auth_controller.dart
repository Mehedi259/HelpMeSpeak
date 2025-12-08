// lib/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app/routes/app_routes.dart';
import '../app/constants/api_constants.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';
import '../data/services/auth_service.dart';
import '../utils/storage_helper.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  /// ===== Login =====
  Future<void> login(BuildContext context, String email, String password,
      {required bool rememberMe}) async {
    try {
      isLoading.value = true;

      final res = await AuthService.login(email, password);
      print("🚀 Login response: $res");

      String? token;
      if (res.containsKey("access_token")) {
        token = res["access_token"]?.toString();
      } else if (res.containsKey("access")) {
        token = res["access"]?.toString();
      } else if (res.containsKey("token")) {
        token = res["token"]?.toString();
      }

      if (token != null && token.trim().isNotEmpty) {
        token = token.trim();
        await StorageHelper.saveToken(token);

        final saved = await StorageHelper.getToken();
        print("🔐 Saved token: $saved");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful")),
        );

        context.go(AppRoutes.subscription);
      } else {
        String message = "Login failed";
        if (res.containsKey("message")) {
          message = res["message"].toString();
        } else if (res.containsKey("detail")) {
          message = res["detail"].toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Register =====
  Future<void> register(
      BuildContext context,
      String username,
      String email,
      String password,
      String confirmPassword,
      String fullName,
      ) async {
    try {
      isLoading.value = true;
      final res = await AuthService.register({
        "username": username,
        "email": email,
        "password": password,
        "password_confirm": confirmPassword,
        "full_name": fullName,
      });

      if (res["message"] != null &&
          res["message"].toString().contains("Verification OTP")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"])),
        );

        context.push(AppRoutes.authOtp, extra: {"email": email});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Register failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Verify OTP =====
  Future<void> verifyOtp(
      BuildContext context, String email, String code, String purpose) async {
    try {
      isLoading.value = true;
      final res = await AuthService.verifyOtp({
        "email": email,
        "otp": code,
        "purpose": purpose,
      });

      if (res["success"] == true || res["email_verified"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "OTP Verified")),
        );

        context.go(AppRoutes.onboarding1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "OTP verification failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Fetch User Data =====
  Future<void> fetchUserData() async {
    try {
      final data = await ApiService.getRequest(ApiConstants.profile);

      if (data != null && data is Map<String, dynamic>) {
        String profileImage = "";

        if (data["profile_image"] != null &&
            data["profile_image"].toString().isNotEmpty &&
            data["profile_image"].toString() != "null") {
          profileImage = data["profile_image"].toString();

          if (!profileImage.startsWith("http")) {
            profileImage = "${ApiConstants.baseUrl}$profileImage";
          }
        }

        user.value = UserModel(
          email: data["email"]?.toString() ?? "",
          fullName: data["full_name"]?.toString() ??
              data["username"]?.toString() ??
              "",
          profileImage: profileImage,
        );

        print("✅ User data loaded: ${user.value?.fullName}");
      } else {
        print("⚠️ Unexpected response format: $data");
        user.value = UserModel(email: "", fullName: "User", profileImage: "");
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
      user.value = UserModel(email: "", fullName: "User", profileImage: "");
    }
  }

  /// ===== Apple Login =====
  Future<void> appleLogin(BuildContext context, {
    required String idToken,
    required String email,
    required String givenName,
    required String familyName,
  }) async {
    try {
      isLoading.value = true;

      print("🍎 Calling Apple Login API...");
      print("📤 ID Token: $idToken");
      print("📤 Email: $email");
      print("📤 Given Name: $givenName");
      print("📤 Family Name: $familyName");

      final res = await AuthService.appleLogin({
        "id_token": idToken,
        "email": email.isNotEmpty ? email : null,
        "first_name": givenName,
        "last_name": familyName,
      });

      print("📥 Apple Login Response: $res");

      if (res["success"] == true) {
        final access = res["access"]?.toString() ?? "";

        if (access.isNotEmpty) {
          await StorageHelper.saveToken(access);
          print("🔐 Apple token saved successfully");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Apple login successful")),
          );

          context.go(AppRoutes.subscription);
        } else {
          print("❌ No access token in response");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to retrieve access token")),
          );
        }
      } else {
        print("❌ Apple login failed: ${res['message'] ?? 'Unknown error'}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Apple login failed")),
        );
      }
    } catch (e) {
      print("❌ Apple login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Google Login ===== ✅ SIMPLE - ONLY EMAIL
  Future<void> googleLogin(BuildContext context) async {
    GoogleSignIn? googleSignIn;

    try {
      isLoading.value = true;

      print("🔵 Starting Google Sign-In...");

      // Initialize GoogleSignIn
      googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      // Sign out first to force account picker
      await googleSignIn.signOut();

      // Start sign in
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ User cancelled Google Sign-In");
        isLoading.value = false;
        return;
      }

      final String email = googleUser.email;
      print("✅ Google user signed in: $email");

      if (email.isEmpty) {
        print("❌ Email is empty");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to get email from Google")),
          );
        }
        isLoading.value = false;
        return;
      }

      print("📤 Sending email to backend: $email");

      // Call backend API with only email
      final res = await AuthService.googleLogin(email);

      print("📥 Backend Response: $res");
      print("📥 Response Keys: ${res.keys.toList()}");

      // Check if success
      if (res["success"] == true) {
        print("✅ Backend returned success");

        // Extract token
        String? token;
        if (res.containsKey("access")) {
          token = res["access"]?.toString();
          print("🔑 Found 'access' token");
        } else if (res.containsKey("access_token")) {
          token = res["access_token"]?.toString();
          print("🔑 Found 'access_token' token");
        } else if (res.containsKey("token")) {
          token = res["token"]?.toString();
          print("🔑 Found 'token' token");
        }

        if (token != null && token.trim().isNotEmpty) {
          await StorageHelper.saveToken(token.trim());
          print("🔐 Token saved successfully");

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Google login successful")),
            );
            context.go(AppRoutes.subscription);
          }
        } else {
          print("❌ No access token in response");
          print("📦 Full response: $res");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No access token received from server")),
            );
          }
        }
      } else {
        print("❌ Backend returned success: false");
        print("📦 Error message: ${res['message'] ?? res['error'] ?? 'Unknown error'}");

        if (context.mounted) {
          final errorMsg = res["message"]?.toString() ??
              res["error"]?.toString() ??
              "Google login failed";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        }
      }
    } catch (e, stackTrace) {
      print("❌ Google login error: $e");
      print("📚 Stack trace: $stackTrace");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      // Clean up - disconnect Google Sign In
      try {
        await googleSignIn?.disconnect();
      } catch (e) {
        print("⚠️ Error disconnecting Google Sign In: $e");
      }

      isLoading.value = false;
    }
  }

  /// ========= Helpers =========
  bool isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  String getSafeProfileImageUrl() {
    final profileImage = user.value?.profileImage ?? "";
    return isValidImageUrl(profileImage) ? profileImage : "";
  }
}