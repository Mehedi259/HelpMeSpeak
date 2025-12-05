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

        context.go(AppRoutes.home);
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

          context.go(AppRoutes.home);
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


  /// ===== Google Login =====
  Future<void> googleLogin(BuildContext context) async {
    try {
      isLoading.value = true;

      print("🔵 Starting Google Sign-In...");

      // ✅ Initialize GoogleSignIn with proper configuration
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>['email', 'profile'],
        serverClientId: '123456789-abc123def456.apps.googleusercontent.com', // ⚠️ Replace with your Web Client ID
      );

      // Ensure clean state
      await googleSignIn.signOut();

      // Initiate sign-in
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ User cancelled Google Sign-In");
        isLoading.value = false;
        return;
      }

      print("✅ Google user signed in: ${googleUser.email}");

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get the server auth code (this is what backend needs)
      final String? serverAuthCode = googleAuth.serverAuthCode;

      if (serverAuthCode == null || serverAuthCode.isEmpty) {
        print("❌ No server auth code received");

        // Fallback: try using idToken if serverAuthCode is null
        final String? idToken = googleAuth.idToken;

        if (idToken == null || idToken.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to get Google authorization")),
          );
          isLoading.value = false;
          return;
        }

        print("🔑 Using ID Token instead: $idToken");

        // Send idToken to backend
        final res = await AuthService.googleLogin(idToken);
        _handleGoogleLoginResponse(context, res);
        return;
      }

      print("🔑 Server Auth Code: $serverAuthCode");

      // Send to backend
      final res = await AuthService.googleLogin(serverAuthCode);
      _handleGoogleLoginResponse(context, res);

    } catch (e) {
      print("❌ Google login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to handle Google login response
  void _handleGoogleLoginResponse(BuildContext context, Map<String, dynamic> res) async {
    print("📥 Google Login Response: $res");

    // Handle response
    String? token;
    if (res.containsKey("access_token")) {
      token = res["access_token"]?.toString();
    } else if (res.containsKey("access")) {
      token = res["access"]?.toString();
    } else if (res.containsKey("token")) {
      token = res["token"]?.toString();
    }

    if (token != null && token.trim().isNotEmpty) {
      await StorageHelper.saveToken(token.trim());
      print("🔐 Google token saved successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google login successful")),
      );

      context.go(AppRoutes.home);
    } else {
      print("❌ No access token in response");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"] ?? "Google login failed")),
      );
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