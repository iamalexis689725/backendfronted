import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final String? Function(String?) validator;

  const AuthInput({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}