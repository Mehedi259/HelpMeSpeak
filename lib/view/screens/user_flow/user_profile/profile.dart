// lib/view/screens/user_flow/user_profile/profile.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/storage_helper.dart';
import '../../../widgets/navigation.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../../controllers/delete_profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  final DeleteProfileController _deleteController = Get.put(DeleteProfileController());

  int _currentIndex = 4;

  // Local data from SharedPreferences
  String? _localGender;
  String? _localDateOfBirth;

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfile();
    _loadLocalData();
  }

  /// Load Gender & DOB from SharedPreferences
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

    // Also clear gender & DOB
    await StorageHelper.clearGender();
    await StorageHelper.clearDateOfBirth();

    if (context.mounted) {
      context.go(AppRoutes.signin);
    }

    // Show success message using ScaffoldMessenger instead of Get.snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("You have been logged out successfully"),
          backgroundColor: Colors.grey.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Delete Account with confirmation
  void _deleteAccount(BuildContext context) async {
    _deleteController.showDeleteConfirmation(
      context,
          () async {
        print("🔥 Delete confirmation accepted");

        final success = await _deleteController.deleteAccount();

        print("🔥 Delete result: $success");

        if (success) {
          if (context.mounted) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Your account has been permanently deleted"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );

            // Wait a bit for the message to show
            await Future.delayed(const Duration(milliseconds: 500));

            // Navigate to sign in screen
            if (context.mounted) {
              print("🔥 Navigating to signin");
              context.go(AppRoutes.signin);
            }
          }
        } else {
          if (context.mounted) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to delete account. Please try again."),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      },
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

                          /// Profile Picture
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

                          /// Edit Profile Button
                          _buildModernButton(
                            onPressed: () async {
                              await context.push(AppRoutes.editProfile);
                              _loadLocalData();
                            },
                            label: "Edit Profile",
                            icon: Icons.edit_rounded,
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.blue.shade800],
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Privacy Policy Button
                          _buildModernButton(
                            onPressed: () async {
                              await context.push(AppRoutes.privacyPolicy);
                              _loadLocalData();
                            },
                            label: "Privacy Policy",
                            icon: Icons.privacy_tip_rounded,
                            gradient: LinearGradient(
                              colors: [Colors.indigo.shade600, Colors.indigo.shade800],
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// Full Name
                          if (profile != null && profile.fullName.isNotEmpty) ...[
                            _buildTextField("Full Name", profile.fullName),
                            const SizedBox(height: 20),
                          ],

                          /// Gender
                          if (_localGender != null && _localGender!.isNotEmpty) ...[
                            _buildTextField(
                              "Gender",
                              _localGender!.substring(0, 1).toUpperCase() +
                                  _localGender!.substring(1),
                            ),
                            const SizedBox(height: 20),
                          ],

                          /// Date of Birth
                          if (_localDateOfBirth != null && _localDateOfBirth!.isNotEmpty) ...[
                            _buildTextField("Date of Birth", _localDateOfBirth!),
                            const SizedBox(height: 20),
                          ],

                          const SizedBox(height: 40),

                          /// Sign Out Button
                          _buildModernOutlineButton(
                            onPressed: () => _signOut(context),
                            label: "Sign Out",
                            icon: Icons.logout_rounded,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(height: 16),

                          /// Delete Account Button
                          Obx(() => _buildModernOutlineButton(
                            onPressed: _deleteController.isDeleting.value
                                ? null
                                : () => _deleteAccount(context),
                            label: "Delete Account",
                            icon: Icons.delete_forever_rounded,
                            color: Colors.red.shade700,
                            isLoading: _deleteController.isDeleting.value,
                          )),
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

  /// Modern Gradient Button
  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Modern Outline Button
  Widget _buildModernOutlineButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: onPressed == null ? Colors.grey.shade300 : color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2.5,
                    ),
                  )
                else ...[
                  Icon(icon, color: onPressed == null ? Colors.grey : color, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: onPressed == null ? Colors.grey : color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextField
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