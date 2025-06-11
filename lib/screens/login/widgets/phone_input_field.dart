import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String errorText;
  final bool showError;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.errorText,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        hintText: 'Enter your number',
        filled: true,
        fillColor: Colors.grey[100],
        counterText: '',
        errorText: showError ? errorText : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
