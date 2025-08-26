import 'package:flutter/material.dart';
class InstantTranslationScreen extends StatelessWidget {
  const InstantTranslationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instant Translation")),
      body: const Center(
        child: Text("Instant Translation Screen (Dummy)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}