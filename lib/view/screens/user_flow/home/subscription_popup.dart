// lib/view/screens/user_flow/home/subscription_popup.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../controllers/subscription_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.subscription.image(fit: BoxFit.cover),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
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
                    ...controller.plans.asMap().entries.map((entry) {
                      final index = entry.key;
                      final plan = entry.value;
                      final product = controller.getProductForPlan(plan);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => controller.selectPlan(index),
                          child: _PlanCard(
                            isSelected: controller.selectedPlanIndex.value == index,
                            headerTitle: _getPlanTitle(plan.name),
                            priceText: product?.price ?? plan.displayPrice,
                            description: _getPlanDescription(plan.name),
                            features: _getPlanFeatures(plan.name),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // Subscribe Button
                    CustomButton(
                      text: 'Subscribe',
                      onPressed: () async {
                        if (controller.selectedPlanIndex.value == -1) {
                          Get.snackbar('Select Plan', 'Please select a subscription plan');
                          return;
                        }

                        final selectedPlan = controller.plans[controller.selectedPlanIndex.value];

                        // Free plan - just navigate
                        if (selectedPlan.name == 'trial' || selectedPlan.price == '0.00') {
                          context.go('/home');
                          return;
                        }

                        // Paid plan - initiate purchase
                        await controller.purchaseSubscription(selectedPlan);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Restore Purchases Button
                    Center(
                      child: TextButton(
                        onPressed: () => controller.restorePurchases(),
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
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getPlanTitle(String planName) {
    switch (planName.toLowerCase()) {
      case 'trial':
        return 'Free';
      case 'monthly':
        return 'Pro Monthly';
      case 'annual':
        return 'Pro Annual';
      default:
        return planName;
    }
  }

  String _getPlanDescription(String planName) {
    switch (planName.toLowerCase()) {
      case 'trial':
        return 'Perfect for casual use—start translating today';
      case 'monthly':
        return 'Unlock unlimited possibilities with monthly flexibility';
      case 'annual':
        return 'Save more with the best value—go annual';
      default:
        return '';
    }
  }

  List<_BulletItem> _getPlanFeatures(String planName) {
    switch (planName.toLowerCase()) {
      case 'trial':
        return const [
          _BulletItem(text: '1 language pair', color: Color(0xFF261E1E)),
          _BulletItem(text: 'Basic phrases', color: Color(0xFF261E1E)),
          _BulletItem(text: 'No offline packs', color: Color(0xFF261E1E)),
        ];
      case 'monthly':
        return const [
          _BulletItem(text: 'Unlimited language pairs', color: Color(0xFF261E1E)),
          _BulletItem(text: 'All phrase library (Phrasebook)', color: Color(0xFF261E1E)),
          _BulletItem(text: 'Offline packs', color: Color(0xFF261E1E)),
        ];
      case 'annual':
        return const [
          _BulletItem(text: 'Same as monthly', color: Color(0xFF261E1E)),
          _BulletItem(text: '≈37–38% cheaper vs monthly', color: Color(0xFF261E1E)),
          _BulletItem(text: 'Optional 7-day trial', color: Color(0xFF261E1E)),
        ];
      default:
        return [];
    }
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
              children: features.map((e) => Padding(
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
              )).toList(),
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