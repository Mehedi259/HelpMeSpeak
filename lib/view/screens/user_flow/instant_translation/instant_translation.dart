import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/navigation.dart';

class InstantTranslationScreen extends StatefulWidget {
  const InstantTranslationScreen({Key? key}) : super(key: key);

  @override
  State<InstantTranslationScreen> createState() => _InstantTranslationScreenState();
}

// ✅ Class name একই করলাম
class _InstantTranslationScreenState extends State<InstantTranslationScreen> {
  int _currentIndex = 1;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/translate');
        break;
      case 2:
        context.go('/chat');
        break;
      case 3:
        context.go('/phrasebook');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Translate Content Here")),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
