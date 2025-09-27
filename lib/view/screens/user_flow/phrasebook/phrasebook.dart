import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../widgets/navigation.dart';
import '../../../../controllers/phrasebook_controller.dart';
import '../../../../data/models/phrase_model.dart' hide Category;
import '../../../../data/models/category_model.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({Key? key}) : super(key: key);

  // Full language list as static const
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
            /// Topbar
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

            /// Main Container
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
                      child: Assets.images.green.image(width: 320, height: 320),
                    ),

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

                            /// Language Selector (Source & Target)
                            _buildLanguageSelector(),
                            const SizedBox(height: 16),

                            /// Category Dropdown
                            _buildCategoryDropdown(),
                            const SizedBox(height: 20),

                            /// Loading indicator for phrases
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

                            /// Phrase list
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Source Language
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
                if (val != null) {
                  _controller.changeSourceLanguage(val);
                }
              },
            ),
          ]),

          // Bidirectional Icon
          GestureDetector(
            onTap: () => _controller.swapLanguages(),
            child: Assets.icons.bidirection.image(width: 26, height: 26),
          ),

          // Target Language
          Row(children: [
            DropdownButton<String>(
              value: _controller.targetLanguage.value,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              items: PhrasebookScreen.allLanguages
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  _controller.changeTargetLanguage(val);
                }
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          value: _controller.selectedCategory.value,
          isExpanded: true,
          icon: Assets.icons.dropdown.image(width: 20, height: 20),
          hint: const Text("Select Category"),
          items: _controller.categories
              .map((category) => DropdownMenuItem(
            value: category,
            child: Text(category.name),
          ))
              .toList(),
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
      // Show phrase languages if available (filtered results)
      if (_controller.phraseLanguages.isNotEmpty) {
        return _buildPhraseLanguagesList();
      }

      // Show regular phrases as fallback
      if (_controller.phrases.isNotEmpty) {
        return _buildRegularPhrasesList();
      }

      // Show empty state
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

        if (sourceText.isEmpty && targetText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 4)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sourceText.isNotEmpty)
                Text(
                  sourceText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (sourceText.isNotEmpty && targetText.isNotEmpty)
                const SizedBox(height: 6),
              if (targetText.isNotEmpty)
                Text(
                  targetText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRegularPhrasesList() {
    return Column(
      children: _controller.phrases.map((phrase) {
        final sourceText = _getTranslationFromPhrase(phrase, _controller.sourceLanguage.value);
        final targetText = _getTranslationFromPhrase(phrase, _controller.targetLanguage.value);

        if (sourceText.isEmpty && targetText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 4)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sourceText.isNotEmpty)
                Text(
                  sourceText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (sourceText.isNotEmpty && targetText.isNotEmpty)
                const SizedBox(height: 6),
              if (targetText.isNotEmpty)
                Text(
                  targetText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getTranslationFromPhrase(Phrase phrase, String language) {
    // Exact match
    if (phrase.translatedText.containsKey(language)) {
      return phrase.translatedText[language]?.toString() ?? '';
    }

    // Lowercase match
    String lowerLang = language.toLowerCase();
    if (phrase.translatedText.containsKey(lowerLang)) {
      return phrase.translatedText[lowerLang]?.toString() ?? '';
    }

    // Language variations mapping
    Map<String, List<String>> languageVariations = {
      'afrikaans': ['af','afrikaans_text'],
      'albanian': ['sq','albanian_text'],
      'arabic': ['ar','arabic_text'],
      'armenian': ['hy','armenian_text'],
      'bengali': ['bn','bengali_text'],
      'bosnian': ['bs','bosnian_text'],
      'catalan': ['ca','catalan_text'],
      'croatian': ['hr','croatian_text'],
      'czech': ['cs','czech_text'],
      'danish': ['da','danish_text'],
      'dutch': ['nl','dutch_text'],
      'english': ['en','english_text'],
      'esperanto': ['eo','esperanto_text'],
      'estonian': ['et','estonian_text'],
      'finnish': ['fi','finnish_text'],
      'french': ['fr','french_text'],
      'german': ['de','german_text'],
      'greek': ['el','greek_text'],
      'gujarati': ['gu','gujarati_text'],
      'hindi': ['hi','hindi_text'],
      'hungarian': ['hu','hungarian_text'],
      'icelandic': ['is','icelandic_text'],
      'indonesian': ['id','indonesian_text'],
      'italian': ['it','italian_text'],
      'japanese': ['ja','japanese_text'],
      'javanese': ['jv','javanese_text'],
      'kannada': ['kn','kannada_text'],
      'khmer': ['km','khmer_text'],
      'korean': ['ko','korean_text'],
      'latin': ['la','latin_text'],
      'latvian': ['lv','latvian_text'],
      'lithuanian': ['lt','lithuanian_text'],
      'macedonian': ['mk','macedonian_text'],
      'malayalam': ['ml','malayalam_text'],
      'marathi': ['mr','marathi_text'],
      'burmese': ['my','burmese_text'],
      'nepali': ['ne','nepali_text'],
      'norwegian': ['no','norwegian_text'],
      'chichewa': ['ny','chichewa_text'],
      'odia': ['or','odia_text'],
      'pashto': ['ps','pashto_text'],
      'persian': ['fa','persian_text'],
      'polish': ['pl','polish_text'],
      'portuguese': ['pt','portuguese_text'],
      'punjabi': ['pa','punjabi_text'],
      'romanian': ['ro','romanian_text'],
      'russian': ['ru','russian_text'],
      'serbian': ['sr','serbian_text'],
      'sinhala': ['si','sinhala_text'],
      'slovak': ['sk','slovak_text'],
      'slovenian': ['sl','slovenian_text'],
      'spanish': ['es','spanish_text'],
      'sundanese': ['su','sundanese_text'],
      'swahili': ['sw','swahili_text'],
      'swedish': ['sv','swedish_text'],
      'tamil': ['ta','tamil_text'],
      'telugu': ['te','telugu_text'],
      'thai': ['th','thai_text'],
      'turkish': ['tr','turkish_text'],
      'ukrainian': ['uk','ukrainian_text'],
      'urdu': ['ur','urdu_text'],
      'vietnamese': ['vi','vietnamese_text'],
      'welsh': ['cy','welsh_text'],
      'xhosa': ['xh','xhosa_text'],
      'yiddish': ['yi','yiddish_text'],
      'zulu': ['zu','zulu_text'],
    };

    if (languageVariations.containsKey(lowerLang)) {
      for (String variation in languageVariations[lowerLang]!) {
        if (phrase.translatedText.containsKey(variation)) {
          return phrase.translatedText[variation]?.toString() ?? '';
        }
      }
    }

    return '';
  }
}
