// lib/view/screens/ai_chatbot/ai_chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../gen/assets.gen.dart';
import '../../../widgets/navigation.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/app_routes.dart';

class AiChatBotScreen extends StatefulWidget {
  const AiChatBotScreen({Key? key}) : super(key: key);

  @override
  State<AiChatBotScreen> createState() => _AiChatBotScreenState();
}

class _AiChatBotScreenState extends State<AiChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech(); // initialize only once
  }

  Future<void> _initSpeech() async {
    // 🔑 runtime permission check
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      _speechAvailable = await _speech.initialize();
    } else {
      _speechAvailable = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Microphone permission denied"),
          ),
        );
      }
    }
    setState(() {});
  }

  void _listen() async {
    if (!_speechAvailable) return; // if speech not ready, do nothing

    if (!_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
          time: "Now",
        ));
        _messageController.clear();
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChatMessage(
            text: "I'd be happy to help you with that translation!",
            isUser: false,
            time: "Now",
          ));
        });
      });
    }
  }

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
                      "Ai Chat Bot",
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

            /// Chat container
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
                    /// ==== Background Icons (Static) ====
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

                    /// ==== Foreground (Messages + Input) ====
                    Column(
                      children: [
                        /// Chat messages
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) =>
                                _buildChatBubble(_messages[index]),
                          ),
                        ),

                        /// Input Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          decoration: const InputDecoration(
                                            hintText: "Type something.....",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _sendMessage,
                                        child: Assets.icons.send
                                            .image(width: 25, height: 25),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _listen,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _isListening
                                        ? Colors.red.shade100
                                        : Colors.white, // 🔴 indicator
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Assets.icons.chatbotmic
                                      .image(width: 80, height: 80),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.smart_toy,
                  size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                message.isUser ? const Color(0xFF1E88E5) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=32&h=32&fit=crop&crop=face",
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}
