import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';


/// HomeScreen: Dashboard with background sections and navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  /// Handle bottom navigation tap
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // TODO: Implement bottom nav routing if required
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background image
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
                /// ----------------------------------------
                /// Header section → Profile avatar + texts
                /// ----------------------------------------
                Row(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 2),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Assets.images.profile.provider(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Username + subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello Nurledin",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF202124),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ready to learn today?",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF202124),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// ----------------------------------------
                /// Section 1 (Static Banner: home1sec)
                /// ----------------------------------------
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

                const SizedBox(height: 30),

                /// ----------------------------------------
                /// Section Title
                /// ----------------------------------------
                Text(
                  "Choose a feature to start",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3A4E77),
                  ),
                ),

                const SizedBox(height: 20),

                /// ----------------------------------------
                /// Feature 1 → Instant Translation (home2sec)
                /// ----------------------------------------
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

                const SizedBox(height: 30),

                /// ----------------------------------------
                /// Feature 2 + 3 → AI ChatBot & Phrasebook
                /// ----------------------------------------
                Row(
                  children: [
                    // Left card (AI ChatBot → home3sec)
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

                    // Right card (Phrasebook → home4sec)
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      /// ----------------------------------------
      /// Custom Bottom Navigation
      /// ----------------------------------------
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
