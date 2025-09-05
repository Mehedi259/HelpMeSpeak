import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../../../app/routes/app_routes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/button.dart';

/// SubscriptionScreen
/// Fullscreen subscription selection screen.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.subscription.image(fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional top Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF998888),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Choose the right plan for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF3C7AC0),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Flexible plans to match your needs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xFF676767),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // -------- Plans --------
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: _PlanCard(
                      isSelected: _selectedIndex == 0,
                      headerTitle: 'Free',
                      priceText: '\$0',
                      description: 'Perfect for casual use—start translating today',
                      features: const [
                        _BulletItem(text: '1 language pair', color: Color(0xFF261E1E)),
                        _BulletItem(text: 'Basic phrases', color: Color(0xFF261E1E)),
                        _BulletItem(text: 'No offline packs', color: Color(0xFF261E1E)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 1),
                    child: _PlanCard(
                      isSelected: _selectedIndex == 1,
                      headerTitle: 'Pro Monthly',
                      priceText: '€7.99/month',
                      description: 'Unlock unlimited possibilities with monthly flexibility',
                      features: const [
                        _BulletItem(text: 'Unlimited language pairs', color: Color(0xFF261E1E)),
                        _BulletItem(text: 'All phrase library (Phrasebook)', color: Color(0xFF261E1E)),
                        _BulletItem(text: 'Offline packs', color: Color(0xFF261E1E)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 2),
                    child: _PlanCard(
                      isSelected: _selectedIndex == 2,
                      headerTitle: 'Pro Annual',
                      priceText: '€59.99/year',
                      description: 'Save more with the best value—go annual',
                      features: const [
                        _BulletItem(text: 'Same as monthly', color: Color(0xFF261E1E)),
                        _BulletItem(text: '≈37–38% cheaper vs monthly', color: Color(0xFF261E1E)),
                        _BulletItem(text: 'Optional 7-day trial', color: Color(0xFF261E1E)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  CustomButton(
                    text: 'Subscribe',
                    onPressed: () {
                      context.go(AppRoutes.subscriptionPayment);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plan card widget with selectable styling
class _PlanCard extends StatelessWidget {
  final bool isSelected;
  final String headerTitle;
  final String priceText;
  final String description;
  final List<_BulletItem> features;

  const _PlanCard({
    Key? key,
    required this.isSelected,
    required this.headerTitle,
    required this.priceText,
    required this.description,
    required this.features,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? const Color(0xFF415479) : Colors.white;
    final borderColor = isSelected ? const Color(0xFF7C7C7C) : const Color(0xFFDDDDDD);
    final borderWidth = isSelected ? 2.0 : 1.0;
    final headerTitleColor = isSelected ? Colors.white : const Color(0xFF3B3333);
    final priceColor = isSelected ? const Color(0xFFEFEFEF) : const Color(0xFF415479);
    final descriptionColor = isSelected ? const Color(0xFFC4C0B8) : const Color(0xFF83817C);

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
            SizedBox(
              width: 273,
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 20 / 14,
                      color: headerTitleColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.1,
                      color: priceColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 273,
              child: Column(
                children: features
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : e.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.text,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.1,
                              color: isSelected ? Colors.white : e.color,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
