// lib/view/screens/phrasebook/phrasebook_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';
import '../../../../app/routes/app_routes.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({Key? key}) : super(key: key);

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  int _currentIndex = 3;

  final List<String> _categories = [
    "Travel ✈️",
    "Daily life 🏠",
    "Food & Dining 🍴",
    "Emergency 🚨",
  ];

  String _selectedCategory = "Travel ✈️";

  final Map<String, List<Map<String, String>>> _phrases = {
    "Travel ✈️": [
      {
        "en": "Where is the airport?",
        "es": "¿Dónde está el aeropuerto?"
      },
      {
        "en": "I need a taxi.",
        "es": "Necesito un taxi."
      },
      {
        "en": "How much is the ticket?",
        "es": "¿Cuánto cuesta el boleto?"
      },
      {
        "en": "What time does the bus leave?",
        "es": "¿A qué hora sale el autobús?"
      },
      {
        "en": "How far is it from here?",
        "es": "¿Qué tan lejos está de aquí?"
      },
    ],
    "Daily life 🏠": [
      {"en": "Good morning!", "es": "¡Buenos días!"},
      {"en": "How are you?", "es": "¿Cómo estás?"},
    ],
    "Food & Dining 🍴": [
      {"en": "I am hungry.", "es": "Tengo hambre."},
      {"en": "Can I see the menu?", "es": "¿Puedo ver el menú?"},
    ],
    "Emergency 🚨": [
      {"en": "Call the police!", "es": "¡Llame a la policía!"},
      {"en": "I need help!", "es": "¡Necesito ayuda!"},
    ],
  };

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
            /// ==== Top bar ====
            SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: Assets.icons.backwhite
                          .image(width: 21, height: 21),
                    ),
                    const Spacer(),
                    const Text(
                      "Phrasebook",
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

            /// ==== Main container ====
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
                child: Stack(
                  children: [
                    /// ==== Background Icons ====
                    Center(
                      child: Assets.images.ai.image(width: 142, height: 142),
                    ),
                    Positioned(
                      top: 252,
                      right: 256,
                      child: Assets.images.star.image(width: 71, height: 71),
                    ),
                    Positioned(
                      top: 220,
                      left: -68,
                      child: Assets.images.pink.image(width: 320, height: 320),
                    ),
                    Positioned(
                      top: 220,
                      right: -68,
                      child:
                      Assets.images.green.image(width: 320, height: 320),
                    ),

                    /// ==== Foreground (Dropdown + Phrases) ====

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            "Browse categorized phrases for daily conversations",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Color(0xFF433B3B),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),

                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: Assets.icons.dropdown
                                    .image(width: 20, height: 20),
                                items: _categories
                                    .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCategory = val);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Phrase list
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                              _phrases[_selectedCategory]?.length ?? 0,
                              itemBuilder: (context, index) {
                                final phrase =
                                _phrases[_selectedCategory]![index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        phrase["en"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        phrase["es"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
