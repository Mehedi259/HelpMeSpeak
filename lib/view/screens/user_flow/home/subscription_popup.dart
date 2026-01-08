// lib/view/screens/user_flow/home/subscription_popup.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../gen/assets.gen.dart';
import '../../../widgets/button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlanIndex = -1;

  // Static plan data
  final List<Map<String, dynamic>> plans = [
    {
      'name': 'trial',
      'title': 'Free',
      'price': 'Free',
      'description': 'Perfect for casual use—start translating today',
      'features': [
        '1 language pair',
        'Basic phrases',
        'No offline packs',
      ],
    },
    {
      'name': 'monthly',
      'title': 'Pro Monthly',
      'price': '\$9.99/month',
      'description': 'Unlock unlimited possibilities with monthly flexibility',
      'features': [
        'Unlimited language pairs',
        'All phrase library (Phrasebook)',
        'Offline packs',
      ],
    },
    {
      'name': 'annual',
      'title': 'Pro Annual',
      'price': '\$74.99/year',
      'description': 'Save more with the best value—go annual',
      'features': [
        'Same as monthly',
        '≈37–38% cheaper vs monthly',
        'Optional 7-day trial',
      ],
    },
  ];

  void selectPlan(int index) {
    setState(() {
      selectedPlanIndex = index;
    });
  }

  void handleSubscribe() {
    if (selectedPlanIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subscription plan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final selectedPlan = plans[selectedPlanIndex];

    // Free plan - just navigate
    if (selectedPlan['name'] == 'trial') {
      context.go('/home');
      return;
    }

    // Paid plan - show message (you can implement purchase logic here)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscribing to ${selectedPlan['title']}...'),
        backgroundColor: Colors.blue,
      ),
    );

    // TODO: Implement actual purchase logic here
    // For now, just navigate to home after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void handleRestorePurchases() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restoring purchases...'),
        backgroundColor: Colors.blue,
      ),
    );

    // TODO: Implement restore purchases logic here
  }

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

                  // Plans List
                  ...plans.asMap().entries.map((entry) {
                    final index = entry.key;
                    final plan = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => selectPlan(index),
                        child: _PlanCard(
                          isSelected: selectedPlanIndex == index,
                          headerTitle: plan['title'],
                          priceText: plan['price'],
                          description: plan['description'],
                          features: (plan['features'] as List<String>)
                              .map((text) => _BulletItem(
                            text: text,
                            color: const Color(0xFF261E1E),
                          ))
                              .toList(),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Subscribe Button
                  CustomButton(
                    text: 'Subscribe',
                    onPressed: handleSubscribe,
                  ),

                  const SizedBox(height: 16),

                  // Restore Purchases Button
                  Center(
                    child: TextButton(
                      onPressed: handleRestorePurchases,
                      child: const Text(
                        'Restore Purchases',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF3C7AC0),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
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
            Text(
              headerTitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
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
                color: priceColor,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: descriptionColor,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: features
                  .map((e) => Padding(
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
                          color: isSelected ? Colors.white : e.color,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletItem {
  final String text;
  final Color color;
  const _BulletItem({required this.text, required this.color});
}