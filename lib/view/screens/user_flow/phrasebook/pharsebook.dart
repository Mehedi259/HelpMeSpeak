import 'package:flutter/material.dart';

class PhrasebookScreen extends StatelessWidget {
  const PhrasebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phrasebook")),
      body: const Center(
        child: Text(
          "Phrasebook Screen (Dummy)",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
