import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';
import '../utils/storage_helper.dart';

class ProfileController extends GetxController {
  // Observables
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // User getter for backward compatibility
  ProfileModel? get user => profile.value;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Fetch user profile
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final token = await StorageHelper.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No access token found. Please login again.");
      }

      final fetchedProfile = await ProfileService.getProfile(token);
      profile.value = fetchedProfile;

      // Update controllers with fetched data
      fullNameController.text = fetchedProfile.fullName;
      emailController.text = fetchedProfile.email;

      print("✅ Profile loaded: ${fetchedProfile.fullName}");
    } catch (e) {
      print("❌ Error fetching profile: $e");
      Get.snackbar(
        "Error",
        "Failed to load profile: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user profile (alias for backward compatibility)
  Future<void> loadUserProfile() async {
    await fetchProfile();
  }

  /// Update user profile
  Future<void> updateProfile({
    required String fullName,
    String? gender,
    File? profileImage,
  }) async {
    try {
      isUpdating.value = true;

      final token = await StorageHelper.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No access token found. Please login again.");
      }

      final updatedProfile = await ProfileService.updateProfile(
        fullName: fullName,
        gender: gender,
        profileImage: profileImage,
        token: token,
      );

      profile.value = updatedProfile;
      fullNameController.text = updatedProfile.fullName;
      emailController.text = updatedProfile.email;

      Get.snackbar(
        "Success",
        "Profile updated successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      print("✅ Profile updated: ${updatedProfile.fullName}");
    } catch (e) {
      print("❌ Error updating profile: $e");
      Get.snackbar(
        "Error",
        "Failed to update profile: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update only profile image
  Future<void> updateProfileImage(File profileImage) async {
    if (profile.value == null) return;

    await updateProfile(
      fullName: profile.value!.fullName,
      gender: profile.value!.gender,
      profileImage: profileImage,
    );
  }
}
