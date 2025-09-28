import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  // Mobile image
  File? _profileImage;
  // Web image
  Uint8List? _profileImageBytes;

  final ImagePicker _picker = ImagePicker();

  // GetX Controller
  final ProfileController _profileController = Get.put(ProfileController());

  // Gender selection
  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    // FIXED: Proper async loading without setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.loadUserProfile();
    });
  }


  /// FIXED: Pick image from gallery or camera with Web support
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );

                  if (pickedFile != null) {
                    if (kIsWeb) {
                      // Web platform - use bytes
                      _profileImageBytes = await pickedFile.readAsBytes();
                      setState(() {});

                      await _profileController.updateProfileImage(
                        null, // No File for web
                        webImageBytes: _profileImageBytes,
                      );
                    } else {
                      // Mobile platform - use File
                      _profileImage = File(pickedFile.path);
                      setState(() {});

                      await _profileController.updateProfileImage(_profileImage);
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );

                  if (pickedFile != null) {
                    if (kIsWeb) {
                      // Web platform - use bytes
                      _profileImageBytes = await pickedFile.readAsBytes();
                      setState(() {});

                      await _profileController.updateProfileImage(
                        null,
                        webImageBytes: _profileImageBytes,
                      );
                    } else {
                      // Mobile platform - use File
                      _profileImage = File(pickedFile.path);
                      setState(() {});

                      await _profileController.updateProfileImage(_profileImage);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// FIXED: Save profile changes with Web support
  Future<void> _saveChanges() async {
    await _profileController.updateProfile(
      fullName: _profileController.fullNameController.text,
      gender: _selectedGender,
      profileImage: kIsWeb ? null : _profileImage,
      profileImageBytes: kIsWeb ? _profileImageBytes : null,
    );
  }

  /// FIXED: Get profile image provider with proper Web support
  ImageProvider _getProfileImage() {
    if (kIsWeb && _profileImageBytes != null) {
      return MemoryImage(_profileImageBytes!);
    } else if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_profileController.user?.profileImage != null &&
        _profileController.user!.profileImage.isNotEmpty) {
      return NetworkImage(_profileController.user!.profileImage);
    } else {
      return AssetImage(Assets.images.profile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Edit Profile",
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
                child: Obx(() {
                  if (_profileController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // FIXED: Set gender without causing build issues
                  if (_profileController.user?.gender != null &&
                      _profileController.user!.gender!.isNotEmpty &&
                      _selectedGender != _profileController.user!.gender!) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _selectedGender = _profileController.user!.gender!;
                      });
                    });
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: _getProfileImage(),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: _profileController.isUpdating.value
                                          ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Assets.icons.camera.image(width: 20, height: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildEditableTextField(
                            "Full Name",
                            _profileController.fullNameController,
                          ),
                          const SizedBox(height: 20),
                          _buildReadOnlyTextField(
                            "Email",
                            _profileController.emailController,
                          ),
                          const SizedBox(height: 20),
                          //_buildGenderSelection(),
                          const SizedBox(height: 40),
                          Center(
                            child: Obx(() => ElevatedButton(
                              onPressed: _profileController.isUpdating.value ? null : _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _profileController.isUpdating.value
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.grey.shade600,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, TextEditingController controller) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              controller.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }


}

