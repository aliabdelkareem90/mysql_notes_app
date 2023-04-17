import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  final int maxLines;
  void Function(String?)? onSaved;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;

   CustomTextField({
    super.key,
    this.label = "Email",
    this.maxLines = 1,
    this.isObscure = false,
    required this.textInputAction,
    required this.controller,
    required this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        controller: controller,
        obscureText: isObscure,
        maxLines: maxLines,
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 19.0),
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
