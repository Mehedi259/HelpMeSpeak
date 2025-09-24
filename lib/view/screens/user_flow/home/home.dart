import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../widgets/navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.fetchUserData();
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.homebg.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Avatar + Greetings
                Row(
                  children: [
                    Obx(() {
                      final user = _authController.user.value;
                      final profileUrl = user?.profileImage ?? "";
                      return Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26, width: 2),
                          image: DecorationImage(
                            image: profileUrl.isNotEmpty
                                ? CachedNetworkImageProvider(profileUrl)
                                : Assets.images.profile.provider(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(width: 12),
                    Obx(() {
                      final user = _authController.user.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null && user.fullName.isNotEmpty
                                ? "Hello ${user.fullName}"
                                : "Hello ...",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF202124),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ready to learn today?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF202124),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 5),

                // Static banner
                Container(
                  width: double.infinity,
                  height: 194,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: Assets.images.home1sec.provider(),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Choose a feature to start',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3A4E77),
                  ),
                ),

                const SizedBox(height: 5),

                // Feature 1
                GestureDetector(
                  onTap: () => context.go(AppRoutes.instantTranslation),
                  child: Container(
                    width: double.infinity,
                    height: 168,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31),
                      image: DecorationImage(
                        image: Assets.images.home2sec.provider(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Feature 2 & 3
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.aiChatBot),
                        child: Container(
                          height: 179,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: Assets.images.home3sec.provider(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.phrasebook),
                        child: Container(
                          height: 179,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: Assets.images.home4sec.provider(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
