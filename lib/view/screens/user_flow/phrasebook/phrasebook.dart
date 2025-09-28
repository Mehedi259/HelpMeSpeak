// lib/view/screens/user_flow/phrasebook/phrasebook.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../widgets/navigation.dart';
import '../../../../controllers/phrasebook_controller.dart';
import '../../../../data/models/category_model.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({Key? key}) : super(key: key);

  static const List<String> allLanguages = [
    "Afrikaans","Albanian","Arabic","Armenian","Bengali","Bosnian","Catalan","Croatian",
    "Czech","Danish","Dutch","English","Esperanto","Estonian","Finnish","French","German",
    "Greek","Gujarati","Hindi","Hungarian","Icelandic","Indonesian","Italian","Japanese",
    "Javanese","Kannada","Khmer","Korean","Latin","Latvian","Lithuanian","Macedonian",
    "Malayalam","Marathi","Burmese","Nepali","Norwegian","Chichewa","Odia","Pashto","Persian",
    "Polish","Portuguese","Punjabi","Romanian","Russian","Serbian","Sinhala","Slovak","Slovenian",
    "Spanish","Sundanese","Swahili","Swedish","Tamil","Telugu","Thai","Turkish","Ukrainian",
    "Urdu","Vietnamese","Welsh","Xhosa","Yiddish","Zulu"
  ];

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  final PhrasebookController _controller = Get.put(PhrasebookController());
  int _currentIndex = 3;

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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: Assets.icons.backwhite.image(width: 21, height: 21),
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
                    Center(child: Assets.images.ai.image(width: 142, height: 142)),
                    Positioned(top: 252, right: 256, child: Assets.images.star.image(width: 71, height: 71)),
                    Positioned(top: 220, left: -68, child: Assets.images.pink.image(width: 320, height: 320)),
                    Positioned(top: 220, right: -68, child: Assets.images.green.image(width: 320, height: 320)),
                    Obx(() {
                      if (_controller.isCategoriesLoading.value) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text("Loading categories..."),
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
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
                            _buildLanguageSelector(),
                            const SizedBox(height: 16),
                            _buildCategoryDropdown(),
                            const SizedBox(height: 20),
                            Obx(() {
                              if (_controller.isLoading.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                            _buildPhraseList(),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _controller.sourceLanguage.value,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              items: PhrasebookScreen.allLanguages
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) _controller.changeSourceLanguage(val);
              },
            ),
          ]),
          GestureDetector(
            onTap: () => _controller.swapLanguages(),
            child: Assets.icons.bidirection.image(width: 26, height: 26),
          ),
          Row(children: [
            DropdownButton<String>(
              value: _controller.targetLanguage.value,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              items: PhrasebookScreen.allLanguages
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) _controller.changeTargetLanguage(val);
              },
            ),
            const SizedBox(width: 8),
          ]),
        ],
      ),
    ));
  }

  Widget _buildCategoryDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          value: _controller.selectedCategory.value,
          isExpanded: true,
          icon: Assets.icons.dropdown.image(width: 20, height: 20),
          hint: const Text("Select Category"),
          selectedItemBuilder: (BuildContext context) {
            return _controller.categories.map((category) {
              return Row(
                children: [
                  if (category.icon.isNotEmpty)
                    Image.network(
                      category.icon,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.category, size: 28, color: Colors.grey);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 28,
                          height: 28,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: _controller.categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  if (category.icon.isNotEmpty)
                    Image.network(
                      category.icon,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.category, size: 28, color: Colors.grey);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 28,
                          height: 28,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (category) {
            if (category != null) {
              _controller.changeCategory(category);
            }
          },
        ),
      ),
    ));
  }

  Widget _buildPhraseList() {
    return Obx(() {
      if (_controller.selectedCategory.value == null) {
        return const SizedBox.shrink();
      }

      if (_controller.phraseLanguages.isNotEmpty) {
        return _buildPhraseLanguagesList();
      }

      if (!_controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No phrases found for the selected languages and category",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildPhraseLanguagesList() {
    return Column(
      children: _controller.phraseLanguages.map((phraseLanguage) {
        final sourceText = phraseLanguage.getTranslation(_controller.sourceLanguage.value);
        final targetText = phraseLanguage.getTranslation(_controller.targetLanguage.value);
        if (sourceText.isEmpty && targetText.isEmpty) return const SizedBox.shrink();

        return _buildPhraseCard(sourceText, targetText);
      }).toList(),
    );
  }

  Widget _buildPhraseCard(String sourceText, String targetText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sourceText.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.record_voice_over, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sourceText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          if (sourceText.isNotEmpty && targetText.isNotEmpty)
            const Divider(height: 20),
          if (targetText.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.translate, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    targetText,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}