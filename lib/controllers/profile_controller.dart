//lib/controllers/profile_controller.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';
import '../utils/storage_helper.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileModel? get user => profile.value;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Fetch Profile
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("No access token found. Please login again.");
      }

      final fetchedProfile = await ProfileService.getProfile(token);

      // Update UI safely
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profile.value = fetchedProfile;
        fullNameController.text = fetchedProfile.fullName;
        emailController.text = fetchedProfile.email;

        // Set phone if available
        // phoneController.text = fetchedProfile.phone ?? "";
      });

      print("Profile loaded successfully: ${fetchedProfile.fullName}");
    } catch (e) {
      print("Error fetching profile: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Error",
          "Failed to load profile: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;
      });
    }
  }

  /// Load User Profile (alias)
  Future<void> loadUserProfile() async => await fetchProfile();

  /// ✅ Update Profile with proper error handling
  Future<void> updateProfile({
    required String fullName,
    String? gender,
    String? phone,
    File? profileImage,
    Uint8List? profileImageBytes,
  }) async {
    try {
      isUpdating.value = true;
      final token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("No access token found");
      }

      print("Updating profile with:");
      print("- Full Name: $fullName");
      print("- Gender: $gender");
      print("- Phone: $phone");
      print("- Has Image: ${profileImage != null || profileImageBytes != null}");

      final updatedProfile = await ProfileService.updateProfile(
        fullName: fullName,
        gender: gender,
        phone: phone,
        profileImage: profileImage,
        profileImageBytes: profileImageBytes,
        token: token,
      );

      // Update local data
      profile.value = updatedProfile;
      fullNameController.text = updatedProfile.fullName;
      emailController.text = updatedProfile.email;

      Get.snackbar(
        "Success",
        "Profile updated successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 2),
      );

      print("Profile update successful");
    } catch (e) {
      print("Profile update error: $e");

      // User-friendly error messages
      String errorMessage = "Failed to update profile";

      if (e.toString().contains("413")) {
        errorMessage = "Image is too large. Please use a smaller image.";
      } else if (e.toString().contains("401")) {
        errorMessage = "Session expired. Please login again.";
      } else if (e.toString().contains("Connection reset")) {
        errorMessage = "Network error. Please check your connection.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update Profile Image
  Future<void> updateProfileImage(
      File? profileImage, {
        Uint8List? webImageBytes,
      }) async {
    if (profile.value == null) return;

    await updateProfile(
      fullName: profile.value!.fullName,
      gender: profile.value!.gender,
      phone: phoneController.text.isNotEmpty ? phoneController.text : null,
      profileImage: profileImage,
      profileImageBytes: webImageBytes,
    );
  }
}