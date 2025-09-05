// lib/view/screens/instant_translation/instant_translation_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../app/routes/app_routes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';

class InstantTranslationScreen extends StatefulWidget {
  const InstantTranslationScreen({Key? key}) : super(key: key);

  @override
  State<InstantTranslationScreen> createState() =>
      _InstantTranslationScreenState();
}

class _InstantTranslationScreenState extends State<InstantTranslationScreen> {
  int _currentIndex = 1;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _inputText = "";
  String _translatedText = "¿Hola como estas?";

  /// Language state
  String _sourceLanguage = "English";
  String _targetLanguage = "Spanish";

  final List<String> _languages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Hindi",
    "Bengali",
    "Afrikaans",
    "Albanian",
    "Amharic",
    "Arabic",
    "Armenian",
    "Aymara",
    "Azerbaijani",
    "Bambara",
    "Basque",
    "Belarusian",
    "Bhojpuri",
    "Bosnian",
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /// Navigation handler
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

  /// Start or stop voice listening
  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() => _inputText = val.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
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
            image: Assets.images.authbg.provider(), // same bg as AiChatBot
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            /// ==== Topbar ====
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
                      "Talk to Translate",
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

            /// ==== Main Container ====
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
                    /// ==== Background Decoration ====
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

                    /// ==== Foreground (Translation UI) ====
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const Text(
                            "Select Language",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF433B3B),
                            ),
                          ),
                          const SizedBox(height: 12),

                          _buildLanguageSelector(),
                          const SizedBox(height: 30),

                          _buildTranslationBox(
                            language: _sourceLanguage,
                            text: _inputText.isEmpty
                                ? "Hello how are you?"
                                : _inputText,
                            soundIcon: Assets.icons.sound,
                          ),
                          const SizedBox(height: 20),

                          _buildTranslationBox(
                            language: _targetLanguage,
                            text: _translatedText,
                            soundIcon: Assets.icons.sound,
                          ),
                          const SizedBox(height: 30),

                          _buildInputSection(),
                          const SizedBox(height: 100),
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

  /// Language Selector Widget
  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _sourceLanguage,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              items: _languages
                  .map((lang) =>
                  DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _sourceLanguage = val);
                }
              },
            ),
          ]),

          GestureDetector(
            onTap: () {
              setState(() {
                final temp = _sourceLanguage;
                _sourceLanguage = _targetLanguage;
                _targetLanguage = temp;
              });
            },
            child: Assets.icons.bidirection.image(width: 26, height: 26),
          ),

          Row(children: [
            DropdownButton<String>(
              value: _targetLanguage,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              items: _languages
                  .map((lang) =>
                  DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _targetLanguage = val);
                }
              },
            ),
            const SizedBox(width: 8),
          ]),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _inputText = val),
            decoration: InputDecoration(
              hintText: "Type something to translate...",
              hintStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Color(0xFF757575),
                letterSpacing: 0.5,
              ),
              suffixIcon: IconButton(
                icon: Assets.icons.send.image(width: 22, height: 22),
                onPressed: () {
                  // TODO: Handle text translation call
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: _listen,
            child: _isListening
                ? Assets.icons.voiceactive.image(width: 85, height: 85)
                : Assets.icons.voiceinactive.image(width: 85, height: 85),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationBox({
    required String language,
    required String text,
    required AssetGenImage soundIcon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF003366),
                ),
              ),
              soundIcon.image(width: 28, height: 28),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
