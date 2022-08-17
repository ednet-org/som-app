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

  final Color? primary;
  final Color? onPrimary;

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
    this.primary,
    this.onPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: onPrimary ?? Theme.of(context).colorScheme.onPrimary,
          ),
      onChanged: onChanged,
      initialValue: value,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword && showPassword ? false : isPassword,
      autocorrect: autocorrect,
      decoration: InputDecoration(
          labelStyle: TextStyle(
            color: onPrimary ?? Theme.of(context).colorScheme.onPrimary,
          ),
          focusColor: primary ?? Theme.of(context).colorScheme.primary,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: onPrimary ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: onPrimary ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          prefixIconColor: primary ?? Theme.of(context).colorScheme.onPrimary,
          suffixIconColor: primary ?? Theme.of(context).colorScheme.onPrimary,
          labelText: '${label} ${required ? "*" : ""}',
          hintText: hint,
          icon: Icon(icon,
              color: onPrimary ?? Theme.of(context).colorScheme.onPrimary),
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
