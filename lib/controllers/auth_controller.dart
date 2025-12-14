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

  /// ✅ Extract and save tokens
  Future<bool> _saveTokensFromResponse(Map<String, dynamic> res) async {
    // Extract access token
    String? accessToken;
    if (res.containsKey("access_token")) {
      accessToken = res["access_token"]?.toString();
    } else if (res.containsKey("access")) {
      accessToken = res["access"]?.toString();
    } else if (res.containsKey("token")) {
      accessToken = res["token"]?.toString();
    }

    // Extract refresh token
    String? refreshToken;
    if (res.containsKey("refresh_token")) {
      refreshToken = res["refresh_token"]?.toString();
    } else if (res.containsKey("refresh")) {
      refreshToken = res["refresh"]?.toString();
    }

    if (accessToken != null && accessToken.trim().isNotEmpty) {
      await StorageHelper.saveToken(accessToken.trim());

      // Save refresh token if available
      if (refreshToken != null && refreshToken.trim().isNotEmpty) {
        await StorageHelper.saveRefreshToken(refreshToken.trim());
      }

      return true;
    }

    return false;
  }

  /// Login
  Future<void> login(BuildContext context, String email, String password,
      {required bool rememberMe}) async {
    try {
      isLoading.value = true;

      final res = await AuthService.login(email, password);
      print("🚀 Login response: $res");

      if (await _saveTokensFromResponse(res)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful")),
          );
          context.go(AppRoutes.subscription);
        }
      } else {
        String message = res["message"]?.toString() ??
            res["detail"]?.toString() ??
            "Login failed";
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Register
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"])),
          );
          context.push(AppRoutes.authOtp, extra: {"email": email});
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "Register failed")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "OTP Verified")),
          );
          context.go(AppRoutes.onboarding1);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "OTP verification failed")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch User Data
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
        user.value = UserModel(email: "", fullName: "User", profileImage: "");
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
      user.value = UserModel(email: "", fullName: "User", profileImage: "");
    }
  }

  /// Apple Login
  Future<void> appleLogin(BuildContext context, {
    required String idToken,
    required String email,
    required String givenName,
    required String familyName,
  }) async {
    try {
      isLoading.value = true;

      final res = await AuthService.appleLogin({
        "id_token": idToken,
        "email": email.isNotEmpty ? email : null,
        "first_name": givenName,
        "last_name": familyName,
      });

      if (res["success"] == true) {
        if (await _saveTokensFromResponse(res)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Apple login successful")),
            );
            context.go(AppRoutes.subscription);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to retrieve access token")),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "Apple login failed")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Login
  Future<void> googleLogin(BuildContext context) async {
    GoogleSignIn? googleSignIn;

    try {
      isLoading.value = true;

      print("🔵 Starting Google Sign-In...");

      googleSignIn = GoogleSignIn(scopes: ['email']);
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ User cancelled Google Sign-In");
        isLoading.value = false;
        return;
      }

      final String email = googleUser.email;
      print("✅ Google user signed in: $email");

      if (email.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to get email from Google")),
          );
        }
        isLoading.value = false;
        return;
      }

      final res = await AuthService.googleLogin(email);

      if (res["success"] == true) {
        if (await _saveTokensFromResponse(res)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Google login successful")),
            );
            context.go(AppRoutes.subscription);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No access token received")),
            );
          }
        }
      } else {
        if (context.mounted) {
          final errorMsg = res["message"]?.toString() ??
              res["error"]?.toString() ??
              "Google login failed";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      try {
        await googleSignIn?.disconnect();
      } catch (e) {
        print("⚠️ Error disconnecting Google Sign In: $e");
      }
      isLoading.value = false;
    }
  }
}