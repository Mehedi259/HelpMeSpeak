import 'package:flutter/material.dart';

/// Reusable text input field with icon and underline border
class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const InputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.keyboardType,
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
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade400,
            size: 20,
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
