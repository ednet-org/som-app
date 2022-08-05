import 'package:flutter/material.dart';

class SomTextInput extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? hint;
  final bool showPassword;
  final bool isPassword;
  final int maxLines;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final String? value;
  final onChanged;
  final onToggleShowPassword;
  final bool required;

  const SomTextInput({
    Key? key,
    this.label,
    this.icon,
    this.hint,
    this.maxLines = 1,
    this.showPassword = false,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.value,
    this.onChanged,
    this.onToggleShowPassword,
    this.required = false,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: value,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword && showPassword ? false : isPassword,
      autocorrect: autocorrect,
      decoration: InputDecoration(
          labelText: '${label} ${required ? "*" : ""}',
          hintText: hint,
          icon: Icon(icon),
          suffixIcon: isPassword ? obscureTextIcon() : null),
    );
  }

  GestureDetector obscureTextIcon() {
    return GestureDetector(
      onTap: () {
        onToggleShowPassword();
      },
      child: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
    );
  }
}
