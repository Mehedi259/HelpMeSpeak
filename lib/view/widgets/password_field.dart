import 'package:flutter/material.dart';

/// Reusable password input field with visibility toggle
class PasswordField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;

  const PasswordField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    required this.isVisible,
    required this.onVisibilityToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade400,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade400,
              size: 20,
            ),
            onPressed: onVisibilityToggle,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
