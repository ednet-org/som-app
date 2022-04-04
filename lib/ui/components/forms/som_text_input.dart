import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class SomTextInput extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? hint;
  final bool obscureText;
  final int maxLines;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final String? value;
  final onChanged;

  const SomTextInput({
    Key? key,
    this.label,
    this.icon,
    this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: value,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: primaryTextStyle(),
      obscureText: obscureText,
      autocorrect: autocorrect,
      decoration: InputDecoration(
        labelText: label,
        hintStyle: secondaryTextStyle(),
        labelStyle: secondaryTextStyle(),
        hintText: hint,
        icon: Icon(icon, color: appStore.iconColor),
      ),
    );
  }
}
