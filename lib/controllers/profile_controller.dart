import 'dart:ui';

import 'package:get/get.dart';
import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await ProfileService.getProfile();
      profile.value = data;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB00020),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
