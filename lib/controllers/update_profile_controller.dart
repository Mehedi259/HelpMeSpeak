// lib/controllers/profile_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';
import '../utils/storage_helper.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  RxBool isLoading = false.obs;

  Future<void> fetchProfile() async {
    final token = await StorageHelper.getToken();
    if (token == null) return;
    isLoading.value = true;
    final data = await ProfileService.getProfile(token);
    profile.value = data;
    isLoading.value = false;
  }

  Future<bool> updateProfile(String fullName, File? profileImage) async {
    final token = await StorageHelper.getToken();
    if (token == null) return false;
    isLoading.value = true;
    final updatedProfile = await ProfileService.updateProfile(
      token: token,
      fullName: fullName,
      profileImage: profileImage,
    );
    profile.value = updatedProfile;
    isLoading.value = false;
    return true;
  }
}
