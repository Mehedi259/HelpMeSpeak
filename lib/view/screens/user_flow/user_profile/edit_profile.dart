import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _currentIndex = 4;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.loadUserProfile();
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

  /// Pick image from gallery or camera
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
                    } else {
                      _profileImage = File(pickedFile.path);
                    }
                    setState(() {});
                    await _profileController.updateProfileImage(
                      kIsWeb
                          ? File(pickedFile.path) // Optional, API may handle differently
                          : File(pickedFile.path),
                    );
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
                    } else {
                      _profileImage = File(pickedFile.path);
                    }
                    setState(() {});
                    await _profileController.updateProfileImage(
                      kIsWeb
                          ? File(pickedFile.path)
                          : File(pickedFile.path),
                    );
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
    await _profileController.updateProfile(
      fullName: _profileController.fullNameController.text,
      gender: _selectedGender,
      profileImage: kIsWeb ? null : _profileImage,
    );
  }

  /// Get profile image provider
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.profile),
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

                  if (_profileController.user?.gender != null &&
                      _profileController.user!.gender!.isNotEmpty) {
                    _selectedGender = _profileController.user!.gender!;
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
                          _buildGenderSelection(),
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
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("Male"),
                  value: "male",
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("Female"),
                  value: "female",
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../gen/assets.gen.dart';
// import '../../../widgets/navigation.dart';
// import '../../../../app/routes/app_routes.dart';
// import '../../../../controllers/profile_controller.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   int _currentIndex = 4;
//
//   // Mobile image
//   File? _profileImage;
//
//   // Web image
//   Uint8List? _profileImageBytes;
//
//   final ImagePicker _picker = ImagePicker();
//
//   // GetX Controller
//   final ProfileController _profileController = Get.put(ProfileController());
//
//   // Gender selection
//   String _selectedGender = 'male';
//
//   @override
//   void initState() {
//     super.initState();
//     // Load user profile data
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _profileController.loadUserProfile();
//     });
//   }
//
//   void _onNavTap(int index) {
//     setState(() => _currentIndex = index);
//     switch (index) {
//       case 0:
//         context.go(AppRoutes.home);
//         break;
//       case 1:
//         context.go(AppRoutes.instantTranslation);
//         break;
//       case 2:
//         context.go(AppRoutes.aiChatBot);
//         break;
//       case 3:
//         context.go(AppRoutes.phrasebook);
//         break;
//       case 4:
//         context.go(AppRoutes.profile);
//         break;
//     }
//   }
//
//   /// Pick image from gallery or camera
//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final XFile? pickedFile = await _picker.pickImage(
//                     source: ImageSource.gallery,
//                     imageQuality: 85,
//                   );
//                   if (pickedFile != null) {
//                     if (kIsWeb) {
//                       _profileImageBytes = await pickedFile.readAsBytes();
//                     } else {
//                       _profileImage = File(pickedFile.path);
//                     }
//                     setState(() {});
//                     // Update profile image immediately
//                     await _profileController.updateProfileImage(
//                       kIsWeb
//                           ? File(pickedFile.path) // optional for API upload
//                           : File(pickedFile.path),
//                     );
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final XFile? pickedFile = await _picker.pickImage(
//                     source: ImageSource.camera,
//                     imageQuality: 85,
//                   );
//                   if (pickedFile != null) {
//                     if (kIsWeb) {
//                       _profileImageBytes = await pickedFile.readAsBytes();
//                     } else {
//                       _profileImage = File(pickedFile.path);
//                     }
//                     setState(() {});
//                     // Update profile image immediately
//                     await _profileController.updateProfileImage(
//                       kIsWeb
//                           ? File(pickedFile.path)
//                           : File(pickedFile.path),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// Save profile changes
//   Future<void> _saveChanges() async {
//     await _profileController.updateProfile(
//       fullName: _profileController.fullNameController.text,
//       gender: _selectedGender,
//       profileImage: kIsWeb
//           ? null // Web API upload handled separately if needed
//           : _profileImage,
//     );
//   }
//
//   /// Get profile image provider
//   ImageProvider _getProfileImage() {
//     if (kIsWeb && _profileImageBytes != null) {
//       return MemoryImage(_profileImageBytes!);
//     } else if (_profileImage != null) {
//       return FileImage(_profileImage!);
//     } else if (_profileController.user?.profileImage != null &&
//         _profileController.user!.profileImage.isNotEmpty) {
//       return NetworkImage(_profileController.user!.profileImage);
//     } else {
//       return AssetImage(Assets.images.profile.path);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CustomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onNavTap,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: Assets.images.authbg.provider(),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             /// Top Bar
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => context.go(AppRoutes.profile),
//                       child: Assets.icons.backwhite.image(width: 21, height: 21),
//                     ),
//                     const Spacer(),
//                     const Text(
//                       "Edit Profile",
//                       style: TextStyle(
//                         fontFamily: "Pontano Sans",
//                         fontWeight: FontWeight.w600,
//                         fontSize: 21,
//                         letterSpacing: 0.5,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// Main Container
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(59),
//                     topRight: Radius.circular(59),
//                   ),
//                 ),
//                 child: Obx(() {
//                   if (_profileController.isLoading.value) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//
//                   // Set selected gender from user data
//                   if (_profileController.user?.gender != null &&
//                       _profileController.user!.gender!.isNotEmpty) {
//                     _selectedGender = _profileController.user!.gender!;
//                   }
//
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//
//                           /// Profile Picture + Camera Icon
//                           Center(
//                             child: Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 60,
//                                   backgroundImage: _getProfileImage(),
//                                 ),
//                                 Positioned(
//                                   bottom: 0,
//                                   right: 6,
//                                   child: GestureDetector(
//                                     onTap: _pickImage,
//                                     child: CircleAvatar(
//                                       radius: 18,
//                                       backgroundColor: Colors.white,
//                                       child: _profileController.isUpdating.value
//                                           ? const SizedBox(
//                                         width: 16,
//                                         height: 16,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                         ),
//                                       )
//                                           : Assets.icons.camera.image(width: 20, height: 20),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//
//                           /// Full Name with Edit Icon
//                           _buildEditableTextField(
//                             "Full Name",
//                             _profileController.fullNameController,
//                           ),
//                           const SizedBox(height: 20),
//
//                           /// Email (Read only)
//                           _buildReadOnlyTextField(
//                             "Email",
//                             _profileController.emailController,
//                           ),
//                           const SizedBox(height: 20),
//
//                           /// Gender Selection
//                           _buildGenderSelection(),
//                           const SizedBox(height: 40),
//
//                           /// Save Changes Button
//                           Center(
//                             child: Obx(() => ElevatedButton(
//                               onPressed: _profileController.isUpdating.value ? null : _saveChanges,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue.shade700,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 40, vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: _profileController.isUpdating.value
//                                   ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                                   : const Text(
//                                 "Save Changes",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             )),
//                           ),
//                           const SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Editable TextField with Edit Icon
//   Widget _buildEditableTextField(String label, TextEditingController controller) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 suffixIcon: Icon(
//                   Icons.edit,
//                   color: Colors.grey.shade600,
//                 ),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Read only TextField
//   Widget _buildReadOnlyTextField(String label, TextEditingController controller) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               controller.text,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Gender Selection Widget
//   Widget _buildGenderSelection() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Gender",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               Expanded(
//                 child: RadioListTile<String>(
//                   title: const Text("Male"),
//                   value: "male",
//                   groupValue: _selectedGender,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedGender = value!;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: RadioListTile<String>(
//                   title: const Text("Female"),
//                   value: "female",
//                   groupValue: _selectedGender,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedGender = value!;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
