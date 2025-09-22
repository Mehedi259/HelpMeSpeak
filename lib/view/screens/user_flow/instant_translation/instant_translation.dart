// // lib/view/screens/instant_translation/instant_translation_screen.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import '../../../../app/routes/app_routes.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../widgets/navigation.dart';
//
// class InstantTranslationScreen extends StatefulWidget {
//   const InstantTranslationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<InstantTranslationScreen> createState() =>
//       _InstantTranslationScreenState();
// }
//
// class _InstantTranslationScreenState extends State<InstantTranslationScreen> {
//   int _currentIndex = 1;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _inputText = "";
//   String _translatedText = "¿Hola como estas?";
//
//   /// Language state
//   String _sourceLanguage = "English";
//   String _targetLanguage = "Spanish";
//
//   final List<String> _languages = [
//     "English",
//     "Spanish",
//     "French",
//     "German",
//     "Hindi",
//     "Bengali",
//     "Afrikaans",
//     "Albanian",
//     "Amharic",
//     "Arabic",
//     "Armenian",
//     "Aymara",
//     "Azerbaijani",
//     "Bambara",
//     "Basque",
//     "Belarusian",
//     "Bhojpuri",
//     "Bosnian",
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//
//   /// Navigation handler
//   void _onNavTap(int index) {
//     setState(() => _currentIndex = index);
//     switch (index) {
//       case 0:
//         context.go(AppRoutes.home);
//         break;
//       case 1:
//         context.go(AppRoutes.instantTranslation);
//         break;
//       case 2:
//         context.go(AppRoutes.aiChatBot);
//         break;
//       case 3:
//         context.go(AppRoutes.phrasebook);
//         break;
//       case 4:
//         context.go(AppRoutes.profile);
//         break;
//     }
//   }
//
//   /// Start or stop voice listening
//   Future<void> _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(onResult: (val) {
//           setState(() => _inputText = val.recognizedWords);
//         });
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CustomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onNavTap,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: Assets.images.authbg.provider(), // same bg as AiChatBot
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             /// ==== Topbar ====
//             SafeArea(
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => context.go(AppRoutes.home),
//                       child: Assets.icons.backwhite
//                           .image(width: 21, height: 21),
//                     ),
//                     const Spacer(),
//                     const Text(
//                       "Talk to Translate",
//                       style: TextStyle(
//                         fontFamily: "Pontano Sans",
//                         fontWeight: FontWeight.w600,
//                         fontSize: 21,
//                         letterSpacing: 0.5,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// ==== Main Container ====
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(59),
//                     topRight: Radius.circular(59),
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     /// ==== Background Decoration ====
//                     Center(
//                       child: Assets.images.ai.image(width: 142, height: 142),
//                     ),
//                     Positioned(
//                       top: 252,
//                       right: 256,
//                       child: Assets.images.star.image(width: 71, height: 71),
//                     ),
//                     Positioned(
//                       top: 220,
//                       left: -68,
//                       child: Assets.images.pink.image(width: 320, height: 320),
//                     ),
//                     Positioned(
//                       top: 220,
//                       right: -68,
//                       child: Assets.images.green.image(width: 320, height: 320),
//                     ),
//
//                     /// ==== Foreground (Translation UI) ====
//                     SingleChildScrollView(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),
//
//                           const Text(
//                             "Select Language",
//                             style: TextStyle(
//                               fontFamily: 'Roboto',
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Color(0xFF433B3B),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//
//                           _buildLanguageSelector(),
//                           const SizedBox(height: 30),
//
//                           _buildTranslationBox(
//                             language: _sourceLanguage,
//                             text: _inputText.isEmpty
//                                 ? "Hello how are you?"
//                                 : _inputText,
//                             soundIcon: Assets.icons.sound,
//                           ),
//                           const SizedBox(height: 20),
//
//                           _buildTranslationBox(
//                             language: _targetLanguage,
//                             text: _translatedText,
//                             soundIcon: Assets.icons.sound,
//                           ),
//                           const SizedBox(height: 30),
//
//                           _buildInputSection(),
//                           const SizedBox(height: 100),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Language Selector Widget
//   Widget _buildLanguageSelector() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       height: 52,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black, blurRadius: 1),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(children: [
//             const SizedBox(width: 8),
//             DropdownButton<String>(
//               value: _sourceLanguage,
//               underline: const SizedBox(),
//               icon: Assets.icons.dropdown.image(width: 20, height: 20),
//               items: _languages
//                   .map((lang) =>
//                   DropdownMenuItem(value: lang, child: Text(lang)))
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) {
//                   setState(() => _sourceLanguage = val);
//                 }
//               },
//             ),
//           ]),
//
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 final temp = _sourceLanguage;
//                 _sourceLanguage = _targetLanguage;
//                 _targetLanguage = temp;
//               });
//             },
//             child: Assets.icons.bidirection.image(width: 26, height: 26),
//           ),
//
//           Row(children: [
//             DropdownButton<String>(
//               value: _targetLanguage,
//               underline: const SizedBox(),
//               icon: Assets.icons.dropdown.image(width: 20, height: 20),
//               items: _languages
//                   .map((lang) =>
//                   DropdownMenuItem(value: lang, child: Text(lang)))
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) {
//                   setState(() => _targetLanguage = val);
//                 }
//               },
//             ),
//             const SizedBox(width: 8),
//           ]),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F2F2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           TextField(
//             onChanged: (val) => setState(() => _inputText = val),
//             decoration: InputDecoration(
//               hintText: "Type something to translate...",
//               hintStyle: const TextStyle(
//                 fontFamily: 'Roboto',
//                 fontSize: 12,
//                 color: Color(0xFF757575),
//                 letterSpacing: 0.5,
//               ),
//               suffixIcon: IconButton(
//                 icon: Assets.icons.send.image(width: 22, height: 22),
//                 onPressed: () {
//
//                 },
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           GestureDetector(
//             onTap: _listen,
//             child: _isListening
//                 ? Assets.icons.voiceactive.image(width: 85, height: 85)
//                 : Assets.icons.voiceinactive.image(width: 85, height: 85),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTranslationBox({
//     required String language,
//     required String text,
//     required AssetGenImage soundIcon,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black, blurRadius: 1),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 language,
//                 style: const TextStyle(
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20,
//                   color: Color(0xFF003366),
//                 ),
//               ),
//               soundIcon.image(width: 28, height: 28),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             text,
//             style: const TextStyle(
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w400,
//               fontSize: 16,
//               color: Colors.black,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// lib/view/screens/instant_translation/instant_translation_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
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
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _inputText = "";
  String _translatedText = "¿Hola como estas?";

  /// Language state
  String _sourceLanguage = "English";
  String _targetLanguage = "Spanish";

  /// Voice selection for each language
  String _sourceVoice = "Male";
  String _targetVoice = "Female";

  final List<String> _voiceOptions = ["Male", "Male 1", "Male 2", "Female", "Female 1", "Female 2"];

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
    _flutterTts = FlutterTts();
    _initTts();
  }

  /// Initialize Text-to-Speech
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  /// Speak text with selected voice
  Future<void> _speak(String text, String language, String voice) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    setState(() => _isSpeaking = true);

    // Set language code based on selected language
    String languageCode = _getLanguageCode(language);
    await _flutterTts.setLanguage(languageCode);

    // Set voice based on selection (simplified for demo)
    double pitch = voice.contains("Male") ? 0.8 : 1.2;
    await _flutterTts.setPitch(pitch);

    await _flutterTts.speak(text);
  }

  /// Get language code for TTS
  String _getLanguageCode(String language) {
    switch (language) {
      case "English": return "en-US";
      case "Spanish": return "es-ES";
      case "French": return "fr-FR";
      case "German": return "de-DE";
      case "Hindi": return "hi-IN";
      case "Bengali": return "bn-BD";
      default: return "en-US";
    }
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
        _speech.listen(
          onResult: (val) {
            setState(() => _inputText = val.recognizedWords);
            // Auto translate when speech is detected
            if (val.finalResult) {
              _translateText();
            }
          },
          localeId: _getLocaleId(_sourceLanguage),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  /// Get locale ID for speech recognition
  String _getLocaleId(String language) {
    switch (language) {
      case "English": return "en_US";
      case "Spanish": return "es_ES";
      case "French": return "fr_FR";
      case "German": return "de_DE";
      case "Hindi": return "hi_IN";
      case "Bengali": return "bn_BD";
      default: return "en_US";
    }
  }

  /// Translate text (Mock implementation - integrate with real API)
  Future<void> _translateText() async {
    if (_inputText.isEmpty) return;

    // Mock translation logic - replace with real API call
    setState(() {
      if (_sourceLanguage == "English" && _targetLanguage == "Spanish") {
        _translatedText = "¡Hola! ¿Cómo estás?";
      } else if (_sourceLanguage == "English" && _targetLanguage == "Bengali") {
        _translatedText = "হ্যালো! তুমি কেমন আছো?";
      } else {
        _translatedText = "Translated: $_inputText";
      }
    });
  }

  /// Show voice selection dialog
  void _showVoiceSelector(bool isSource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Voice"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _voiceOptions.length,
              itemBuilder: (context, index) {
                String voice = _voiceOptions[index];
                bool isSelected = isSource
                    ? _sourceVoice == voice
                    : _targetVoice == voice;

                return ListTile(
                  title: Text(voice),
                  leading: Icon(
                    voice.contains("Female") ? Icons.person : Icons.person_outline,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () {
                    setState(() {
                      if (isSource) {
                        _sourceVoice = voice;
                      } else {
                        _targetVoice = voice;
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
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
            /// ==== Topbar ====
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
                            text: _inputText.isEmpty ? "Hello how are you?" : _inputText,
                            soundIcon: Assets.icons.sound,
                            isSource: true,
                            selectedVoice: _sourceVoice,
                          ),
                          const SizedBox(height: 20),

                          _buildTranslationBox(
                            language: _targetLanguage,
                            text: _translatedText,
                            soundIcon: Assets.icons.sound,
                            isSource: false,
                            selectedVoice: _targetVoice,
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
          BoxShadow(color: Colors.black, blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _sourceLanguage,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              isExpanded: true,
              items: _languages
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _sourceLanguage = val);
                }
              },
            ),
          ),

          GestureDetector(
            onTap: () {
              setState(() {
                final temp = _sourceLanguage;
                _sourceLanguage = _targetLanguage;
                _targetLanguage = temp;

                final tempVoice = _sourceVoice;
                _sourceVoice = _targetVoice;
                _targetVoice = tempVoice;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Assets.icons.bidirection.image(width: 26, height: 26),
            ),
          ),

          Expanded(
            child: DropdownButton<String>(
              value: _targetLanguage,
              underline: const SizedBox(),
              icon: Assets.icons.dropdown.image(width: 20, height: 20),
              isExpanded: true,
              items: _languages
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _targetLanguage = val);
                }
              },
            ),
          ),
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
                onPressed: _translateText,
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isListening ? Colors.red : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: _isListening
                  ? Assets.icons.voiceactive.image(width: 85, height: 85)
                  : Assets.icons.voiceinactive.image(width: 85, height: 85),
            ),
          ),

          if (_isListening)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Listening...",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTranslationBox({
    required String language,
    required String text,
    required AssetGenImage soundIcon,
    required bool isSource,
    required String selectedVoice,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 4),
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
              Row(
                children: [
                  // Voice selection button
                  GestureDetector(
                    onTap: () => _showVoiceSelector(isSource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selectedVoice.contains("Female") ? Icons.person : Icons.person_outline,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            selectedVoice,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Sound/TTS button
                  GestureDetector(
                    onTap: () => _speak(text, language, selectedVoice),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isSpeaking ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _isSpeaking
                          ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : soundIcon.image(width: 28, height: 28),
                    ),
                  ),
                ],
              ),
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
          ),
        ],
      ),
    );
  }
}