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
  final TextEditingController phoneController = TextEditingController(); // Add phone controller

  ProfileModel? get user => profile.value;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose(); // Dispose phone controller
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final token = await StorageHelper.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No access token found. Please login again.");
      }

      final fetchedProfile = await ProfileService.getProfile(token);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        profile.value = fetchedProfile;
        fullNameController.text = fetchedProfile.fullName;
        emailController.text = fetchedProfile.email;
        // Add phone if your ProfileModel has it
        // phoneController.text = fetchedProfile.phone ?? "";
      });

      print("Profile loaded successfully: ${fetchedProfile.fullName}");
    } catch (e) {
      print("Error fetching profile: $e");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Failed to load profile: $e",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800);
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadUserProfile() async => await fetchProfile();

  Future<void> updateProfile({
    required String fullName,
    String? gender,
    String? phone, // Add phone parameter
    File? profileImage,
    Uint8List? profileImageBytes,
  }) async {
    try {
      isUpdating.value = true;
      final token = await StorageHelper.getToken();
      if (token == null || token.isEmpty) throw Exception("No access token found");

      print("Updating profile with:");
      print("- Full Name: $fullName");
      print("- Gender: $gender");
      print("- Phone: $phone");
      print("- Has Image: ${profileImage != null || profileImageBytes != null}");

      final updatedProfile = await ProfileService.updateProfile(
        fullName: fullName,
        gender: gender,
        phone: phone, // Pass phone to service
        profileImage: profileImage,
        profileImageBytes: profileImageBytes,
        token: token,
      );

      profile.value = updatedProfile;
      fullNameController.text = updatedProfile.fullName;
      emailController.text = updatedProfile.email;
      // phoneController.text = updatedProfile.phone ?? "";

      Get.snackbar("Success", "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800);

      print("Profile update successful");
    } catch (e) {
      print("Profile update error: $e");
      Get.snackbar("Error", "Failed to update profile: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> updateProfileImage(File? profileImage, {Uint8List? webImageBytes}) async {
    if (profile.value == null) return;

    await updateProfile(
      fullName: profile.value!.fullName,
      gender: profile.value!.gender,
      phone: phoneController.text.isNotEmpty ? phoneController.text : "+8801234567890", // Default or current phone
      profileImage: profileImage,
      profileImageBytes: webImageBytes,
    );
  }
}
