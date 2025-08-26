import 'package:flutter/material.dart';
class AiChatBotScreen extends StatelessWidget {
  const AiChatBotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat Bot")),
      body: const Center(
        child: Text("AI Chat Bot Screen (Dummy)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}