import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../../utils/storage_helper.dart';

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

  // Gender selection (NEW - for SharedPreferences only)
  String _selectedGender = 'male';

  // Date of Birth (NEW - for SharedPreferences only)
  DateTime? _selectedDateOfBirth;
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.loadUserProfile();
      _loadLocalData();
    });
  }

  /// Load Gender & DOB from SharedPreferences
  Future<void> _loadLocalData() async {
    final gender = await StorageHelper.getGender();
    final dob = await StorageHelper.getDateOfBirth();

    if (gender != null && gender.isNotEmpty) {
      setState(() {
        _selectedGender = gender;
      });
    }

    if (dob != null && dob.isNotEmpty) {
      setState(() {
        _dobController.text = dob;
        try {
          _selectedDateOfBirth = DateTime.parse(dob);
        } catch (e) {
          print("Error parsing date: $e");
        }
      });
    }
  }

  /// Pick Date of Birth
  Future<void> _pickDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
        // Format: DD/MM/YYYY
        _dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  /// Pick image from gallery or camera with Web support
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
                      _profileImageBytes = await pickedFile.readAsBytes();
                      setState(() {});
                      await _profileController.updateProfileImage(
                        null,
                        webImageBytes: _profileImageBytes,
                      );
                    } else {
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
                      _profileImageBytes = await pickedFile.readAsBytes();
                      setState(() {});
                      await _profileController.updateProfileImage(
                        null,
                        webImageBytes: _profileImageBytes,
                      );
                    } else {
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

  /// Save profile changes
  Future<void> _saveChanges() async {
    // 1. Save to backend (name & profile image - existing functionality)
    await _profileController.updateProfile(
      fullName: _profileController.fullNameController.text,
      gender: _selectedGender, // This might go to backend based on your existing code
      profileImage: kIsWeb ? null : _profileImage,
      profileImageBytes: kIsWeb ? _profileImageBytes : null,
    );

    // 2. Save Gender & DOB to SharedPreferences only (NEW)
    await StorageHelper.saveGender(_selectedGender);
    if (_dobController.text.isNotEmpty) {
      await StorageHelper.saveDateOfBirth(_dobController.text);
    }

    // 3. Show success message
    if (mounted) {
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black87,
        duration: const Duration(seconds: 2),
      );
    }

    // 4. Navigate to Profile screen after saving
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      context.go(AppRoutes.profile);
    }
  }

  /// Get profile image provider with proper Web support
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

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // Profile Picture (existing)
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

                          // Full Name (existing - goes to backend)
                          _buildEditableTextField(
                            "Full Name",
                            _profileController.fullNameController,
                          ),
                          const SizedBox(height: 20),

                          // Gender Selection (NEW - SharedPreferences only)
                          _buildGenderSelection(),
                          const SizedBox(height: 20),

                          // Date of Birth Picker (NEW - SharedPreferences only)
                          _buildDateOfBirthPicker(),
                          const SizedBox(height: 40),

                          // Save Button
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

  // Existing method - Editable TextField (for name - goes to backend)
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

  // NEW - Gender Selection Dropdown (SharedPreferences only)
  Widget _buildGenderSelection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW - Date of Birth Picker (SharedPreferences only)
  Widget _buildDateOfBirthPicker() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date of Birth",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDateOfBirth,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _dobController.text.isEmpty ? "Select Date" : _dobController.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: _dobController.text.isEmpty ? Colors.grey.shade600 : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
                ],
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