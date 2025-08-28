import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../gen/assets.gen.dart';
import '../../app/routes/app_routes.dart';
import 'button.dart';

/// SubscriptionPopup
/// Fullscreen-like popup with rounded top corners and image background.
/// Shown right after sign-in on HomeScreen.
class SubscriptionPopup extends StatelessWidget {
  const SubscriptionPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double topMargin = 66; // As per design: top: 66px

    return Stack(
      children: [
        // Semi-transparent overlay behind the popup for focus
        Positioned.fill(
          child: Container(color: Colors.black),
        ),

        // Main popup body aligned from top with 15px top radius
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topMargin),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                width: media.size.width, // ~442 design maps to full device width
                height: media.size.height - topMargin,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Assets.images.subscription.provider(),
                    fit: BoxFit.cover,
                  ),
                ),

                // Scrollable content to avoid overflow on small screens
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Skip (top-right)
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                height: 1.0,
                                color: Color(0xFF998888),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Title
                        const Center(
                          child: Text(
                            'Choose the right plan for you',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.0,
                              color: Color(0xFF3C7AC0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        const Center(
                          child: Text(
                            'Flexible plans to match your needs.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              height: 1.0,
                              color: Color(0xFF676767),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // -------- Card 1: Free --------
                        _PlanCard(
                          backgroundColor: const Color(0xFF415479),
                          borderColor: const Color(0xFF7C7C7C),
                          borderWidth: 2,
                          headerTitle: 'Free',
                          headerTitleColor: Colors.white,
                          priceText: '\$0',
                          priceColor: const Color(0xFFEFEFEF),
                          description:
                          'Perfect for casual use—start translating today',
                          descriptionColor: const Color(0xFFC4C0B8),
                          headerHeight: 90,
                          features: const [
                            _BulletItem(text: '1 language pair', color: Colors.white),
                            _BulletItem(text: 'Basic phrases', color: Colors.white),
                            _BulletItem(text: 'No offline packs', color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // -------- Card 2: Pro Monthly --------
                        _PlanCard(
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFDDDDDD),
                          borderWidth: 1,
                          headerTitle: 'Pro Monthly',
                          headerTitleColor: const Color(0xFF3B3333),
                          priceText: '€7.99/month',
                          priceColor: const Color(0xFF415479),
                          description:
                          'Unlock unlimited possibilities with monthly flexibility',
                          descriptionColor: const Color(0xFF83817C),
                          headerHeight: 90,
                          features: const [
                            _BulletItem(
                                text: 'Unlimited language pairs',
                                color: Color(0xFF261E1E)),
                            _BulletItem(
                                text: 'All phrase library (Phrasebook)',
                                color: Color(0xFF261E1E)),
                            _BulletItem(
                                text: 'Offline packs', color: Color(0xFF261E1E)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // -------- Card 3: Pro Annual --------
                        _PlanCard(
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFDDDDDD),
                          borderWidth: 1,
                          headerTitle: 'Pro Annual',
                          headerTitleColor: const Color(0xFF3B3333),
                          priceText: '€59.99/year',
                          priceColor: const Color(0xFF415479),
                          description:
                          'Save more with the best value—go annual',
                          descriptionColor: const Color(0xFF83817C),
                          headerHeight: 90,
                          features: const [
                            _BulletItem(
                                text: 'Same as monthly',
                                color: Color(0xFF261E1E)),
                            _BulletItem(
                                text: '≈37–38% cheaper vs monthly',
                                color: Color(0xFF261E1E)),
                            _BulletItem(
                                text: 'Optional 7-day trial',
                                color: Color(0xFF261E1E)),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Subscribe Button
                        CustomButton(
                          text: 'Subscribe',
                          onPressed: () {
                            // Navigate as per given spec
                            context.go(AppRoutes.onboarding2);
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal plan card widget replicating provided measurements and styles.
class _PlanCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final String headerTitle;
  final Color headerTitleColor;
  final String priceText;
  final Color priceColor;
  final String description;
  final Color descriptionColor;
  final double headerHeight;
  final List<_BulletItem> features;

  const _PlanCard({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.headerTitle,
    required this.headerTitleColor,
    required this.priceText,
    required this.priceColor,
    required this.description,
    required this.descriptionColor,
    required this.headerHeight,
    required this.features,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card: width 305, height ~215–235 based on content; responsive with fixed paddings
    return Center(
      child: Container(
        width: 305,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header container (273 x 81 as spec)
            SizedBox(
              width: 273,
              height: headerHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    headerTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 20 / 14,
                      color: headerTitleColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Text(
                    priceText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.1,
                      color: priceColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  SizedBox(
                    width: 273,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.1,
                        color: descriptionColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Features (unordered dotted list)
            SizedBox(
              width: 273,
              child: Column(
                children: features
                    .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dot
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: e.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Text
                      Expanded(
                        child: Text(
                          e.text,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.1,
                            color: e.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bullet item for features list
class _BulletItem {
  final String text;
  final Color color;
  const _BulletItem({required this.text, required this.color});
}
