import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool showPassword;
  final VoidCallback? onTogglePasswordVisibility;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  InputTextField({
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.showPassword = false,
    this.onTogglePasswordVisibility,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText && !showPassword,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: obscureText
            ? IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: onTogglePasswordVisibility,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
