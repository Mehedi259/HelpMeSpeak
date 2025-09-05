// SubscriptionPaymentScreen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/button.dart';
import '../../../../app/routes/app_routes.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  const SubscriptionPaymentScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  bool _appleOffer = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40; // 20px margin each side
    return Scaffold(
      body: Stack(
        children: [
          // Full background image
          Positioned.fill(
            child: Assets.images.subscription.image(fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // AppBar with back button (left) and centered title
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: SizedBox(
                      height: 40,
                      child: Stack(
                        children: [
                          // Back Button (left aligned)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => context.go(AppRoutes.subscription),
                              child: Assets.icons.blackback.image(width: 14, height: 14),
                            ),
                          ),
                          // Title (center aligned)
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Subscription",
                              style: TextStyle(
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Color(0xFF413E3E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Crown image
                  Center(
                    child: Assets.images.crown.image(width: 81, height: 81),
                  ),
                  const SizedBox(height: 5),

                  // Pro Monthly Plan
                  const Center(
                    child: Text(
                      "Pro Monthly Plan",
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF413E3E),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Card container
                  Center(
                    child: Container(
                      width: cardWidth,
                      height: 450,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Apple Pay container
                          Positioned(
                            top: 43,
                            left: cardWidth / 2 - 60,
                            child: Row(
                              children: [
                                Assets.icons.apple.image(width: 18, height: 24),
                                const SizedBox(width: 10),
                                const Text(
                                  "Apple Store pay",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // "Complete your Purchase"
                          const Positioned(
                            top: 115,
                            left: 20,
                            right: 20,
                            child: Center(
                              child: Text(
                                "Complete your Purchase",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Color(0xB2000000),
                                ),
                              ),
                            ),
                          ),

                          // Email input box
                          Positioned(
                            top: 160,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0x24000000)),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Enter your Email",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  hintStyle: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0x80000000),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Payment Method label
                          const Positioned(
                            top: 220,
                            left: 20,
                            child: Text(
                              "Payment Method",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xAB000000),
                              ),
                            ),
                          ),

                          // Card input
                          Positioned(
                            top: 245,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: const Color(0x24000000)),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Assets.icons.mastercard.image(width: 20, height: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _cardController,
                                      decoration: const InputDecoration(
                                        hintText: "MasterCard 13345***44",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                                        hintStyle: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xCC000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Checkbox with text
                          Positioned(
                            top: 320,
                            left: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _appleOffer,
                                  onChanged: (val) {
                                    setState(() {
                                      _appleOffer = val ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    "Pay with Apple pay and get offers and discount in your next purchase",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Pay label and price
                          const Positioned(
                            bottom: 25,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pay",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xCC000000),
                                  ),
                                ),
                                Text(
                                  "€7.99",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xCC000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Pay Now button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Pay Now",
                      onPressed: () {
                        context.go(AppRoutes.home);
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
