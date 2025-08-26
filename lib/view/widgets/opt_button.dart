// lib/view/widgets/opt_button.dart

import 'package:flutter/material.dart';

class OptButton extends StatelessWidget {
  final String text;
  final bool isEnabled; // OTP complete হলে true হবে
  final VoidCallback onPressed;

  const OptButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 343,
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFF3C7AC0) // Active background
              : const Color(0x7A048BC2), // Inactive background (#048BC27A)
          borderRadius: BorderRadius.circular(10),
          boxShadow: isEnabled
              ? const [
            BoxShadow(
              color: Color(0x1A000000), // #0000001A
              offset: Offset(0, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Color(0x17000000), // #00000017
              offset: Offset(0, 22),
              blurRadius: 22,
            ),
            BoxShadow(
              color: Color(0x0D000000), // #0000000D
              offset: Offset(0, 50),
              blurRadius: 30,
            ),
            BoxShadow(
              color: Color(0x03000000), // #00000003
              offset: Offset(0, 88),
              blurRadius: 35,
            ),
            BoxShadow(
              color: Color(0x00000000), // #00000000
              offset: Offset(0, 138),
              blurRadius: 39,
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
