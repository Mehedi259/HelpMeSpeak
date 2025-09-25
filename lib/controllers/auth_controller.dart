// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../app/routes/app_routes.dart';
// import '../app/constants/api_constants.dart';
// import '../data/models/user_model.dart';
// import '../data/services/api_service.dart';
// import '../data/services/auth_service.dart';
// import '../utils/storage_helper.dart';
//
// class AuthController extends GetxController {
//   var isLoading = false.obs;
//   var user = Rxn<UserModel>();
//
//   // ===== Login =====
//   Future<void> login(BuildContext context, String email, String password,
//       {required bool rememberMe}) async {
//     try {
//       isLoading.value = true;
//
//       final res = await AuthService.login(email, password);
//
//       if (res["access_token"] != null) {
//         await StorageHelper.saveToken(res["access_token"]);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login successful")),
//         );
//
//         context.go(AppRoutes.home);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res["message"] ?? "Login failed")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ===== Register =====
//   Future<void> register(
//       BuildContext context,
//       String username,
//       String email,
//       String password,
//       String confirmPassword,
//       String fullName,
//       ) async {
//     try {
//       isLoading.value = true;
//       final res = await AuthService.register({
//         "username": username,
//         "email": email,
//         "password": password,
//         "password_confirm": confirmPassword,
//         "full_name": fullName,
//       });
//
//       if (res["message"] != null &&
//           res["message"].toString().contains("Verification OTP")) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res["message"])),
//         );
//
//         context.push(AppRoutes.authOtp, extra: {"email": email});
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res["message"] ?? "Register failed")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ===== Verify OTP =====
//   Future<void> verifyOtp(
//       BuildContext context, String email, String code, String purpose) async {
//     try {
//       isLoading.value = true;
//       final res = await AuthService.verifyOtp({
//         "email": email,
//         "otp": code,
//         "purpose": purpose,
//       });
//
//       if (res["success"] == true || res["email_verified"] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res["message"] ?? "OTP Verified")),
//         );
//
//         context.go(AppRoutes.onboarding1);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res["message"] ?? "OTP verification failed")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ============ Fetch User Data ===============
//   Future<void> fetchUserData() async {
//     try {
//       final data = await ApiService.getRequest("/auth/me/");
//
//       if (data != null && data is Map<String, dynamic>) {
//         String profileImage = "";
//
//         if (data["profile_image"] != null &&
//             data["profile_image"].toString().isNotEmpty &&
//             data["profile_image"].toString() != "null") {
//           profileImage = data["profile_image"].toString();
//
//           if (!profileImage.startsWith("http")) {
//             profileImage = "${ApiConstants.baseUrl}$profileImage";
//           }
//         }
//
//         user.value = UserModel(
//           email: data["email"]?.toString() ?? "",
//           fullName: data["full_name"]?.toString() ??
//               data["username"]?.toString() ??
//               "",
//           profileImage: profileImage,
//         );
//
//         print("User data loaded successfully: ${user.value?.fullName}");
//       } else {
//         print("Unexpected response format: $data");
//         user.value = UserModel(email: "", fullName: "User", profileImage: "");
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//       user.value = UserModel(email: "", fullName: "User", profileImage: "");
//     }
//   }
//
//   bool isValidImageUrl(String url) {
//     if (url.isEmpty) return false;
//     try {
//       final uri = Uri.parse(url);
//       return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
//     } catch (e) {
//       return false;
//     }
//   }
//
//   String getSafeProfileImageUrl() {
//     final profileImage = user.value?.profileImage ?? "";
//     return isValidImageUrl(profileImage) ? profileImage : "";
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../app/routes/app_routes.dart';
import '../app/constants/api_constants.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';
import '../data/services/auth_service.dart';
import '../utils/storage_helper.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  // ===== Login =====
  Future<void> login(BuildContext context, String email, String password,
      {required bool rememberMe}) async {
    try {
      isLoading.value = true;

      final res = await AuthService.login(email, password);

      if (res["access_token"] != null) {
        await StorageHelper.saveToken(res["access_token"]);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful")),
        );

        context.go(AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Login failed")),
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

  // ===== Register =====
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

  // ===== Verify OTP =====
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

  // ============ Fetch User Data ===============
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

  // ========= Helpers =========
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
