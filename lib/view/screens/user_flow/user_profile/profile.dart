// lib/view/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';
import '../../../../app/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4;

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
            /// ==== Top Bar ====
            SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

            /// ==== Main Container ====
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        /// Profile Picture + Camera Icon (Center)
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                AssetImage(Assets.images.profile.path),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 6,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Assets.icons.camera
                                      .image(width: 20, height: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// First Name
                        _buildTextField("First Name", "Nurledin"),
                        const SizedBox(height: 16),

                        /// Last Name
                        _buildTextField("Last Name", "Nurledin"),
                        const SizedBox(height: 16),

                        /// Email
                        _buildTextField("E-mail", "nurledin@gmail.com"),
                        const SizedBox(height: 40),

                        /// Sign Out (Center)
                        Center(
                          child: ElevatedButton(
                            onPressed: () => context.go(AppRoutes.signin),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
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
  }

  /// Reusable TextField (full width, left align)
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
