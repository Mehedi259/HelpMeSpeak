import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/storage_helper.dart';
import '../../../widgets/navigation.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  int _currentIndex = 4;

  // Local data from SharedPreferences (NEW)
  String? _localGender;
  String? _localDateOfBirth;

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfile();
    _loadLocalData();
  }

  /// Load Gender & DOB from SharedPreferences (NEW)
  Future<void> _loadLocalData() async {
    final gender = await StorageHelper.getGender();
    final dob = await StorageHelper.getDateOfBirth();

    setState(() {
      _localGender = gender;
      _localDateOfBirth = dob;
    });
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.instantTranslation);
        break;
      case 2:
        context.go(AppRoutes.aiChatBot);
        break;
      case 3:
        context.go(AppRoutes.phrasebook);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  void _signOut(BuildContext context) async {
    // Clear token from SharedPreferences
    await StorageHelper.clearToken();

    // Also clear gender & DOB (NEW)
    await StorageHelper.clearGender();
    await StorageHelper.clearDateOfBirth();

    if (context.mounted) {
      context.go(AppRoutes.signin);
    }

    Get.snackbar(
      "Signed Out",
      "You have been logged out successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade200,
      colorText: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_profileController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final profile = _profileController.profile.value;

      return Scaffold(
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.authbg.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              /// Top Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.home),
                        child: Assets.icons.backwhite.image(width: 21, height: 21),
                      ),
                      const Spacer(),
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontFamily: "Pontano Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              /// Main Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(59),
                      topRight: Radius.circular(59),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          /// Profile Picture (existing - from backend)
                          Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: (profile != null &&
                                  profile.profileImage.isNotEmpty)
                                  ? CachedNetworkImageProvider(profile.profileImage)
                                  : Assets.images.profile.provider(),
                            ),
                          ),
                          const SizedBox(height: 30),

                          /// Full Name (existing - from backend)
                          if (profile != null && profile.fullName.isNotEmpty) ...[
                            _buildTextField("Full Name", profile.fullName),
                            const SizedBox(height: 20),
                          ],

                          /// Gender (NEW - from SharedPreferences)
                          if (_localGender != null && _localGender!.isNotEmpty) ...[
                            _buildTextField(
                              "Gender",
                              _localGender!.substring(0, 1).toUpperCase() +
                                  _localGender!.substring(1),
                            ),
                            const SizedBox(height: 20),
                          ],

                          /// Date of Birth (NEW - from SharedPreferences)
                          if (_localDateOfBirth != null && _localDateOfBirth!.isNotEmpty) ...[
                            _buildTextField("Date of Birth", _localDateOfBirth!),
                            const SizedBox(height: 20),
                          ],

                          const SizedBox(height: 30),

                          /// Edit Profile Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await context.push(AppRoutes.editProfile);
                                // Reload local data after returning from edit screen
                                _loadLocalData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Sign Out Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _signOut(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Reusable TextField (existing)
  Widget _buildTextField(String label, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}