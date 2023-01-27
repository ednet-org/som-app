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

  final Color? secondary;
  final Color? onSecondary;

  final void Function()? forgotPasswordHandler;

  final bool displayForgotPassword;

  final String? Function(String?)? validator;

  // final Function? forgotPasswordHandler;

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
    this.displayForgotPassword = false,
    this.forgotPasswordHandler,
    this.primary,
    this.secondary,
    this.onSecondary,
    this.onPrimary,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: onPrimary ?? Theme.of(context).colorScheme.secondary,
              ),
          onChanged: onChanged,
          initialValue: value,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: isPassword && showPassword ? false : isPassword,
          autocorrect: autocorrect,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                color: onPrimary ?? Theme.of(context).colorScheme.primary,
              ),
              focusColor:
                  primary ?? Theme.of(context).colorScheme.primaryContainer,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: onPrimary ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: onPrimary ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              prefixIconColor: primary ?? Theme.of(context).colorScheme.primary,
              suffixIconColor: primary ?? Theme.of(context).colorScheme.primary,
              labelText: '$label ${required ? "*" : ""}',
              hintText: hint,
              icon: Icon(icon,
                  color: onPrimary ?? Theme.of(context).colorScheme.primary),
              suffixIcon: isPassword ? obscureTextIcon() : null),
          validator: validator,
        ),
        isPassword && displayForgotPassword
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary:
                        secondary ?? Theme.of(context).colorScheme.secondary,
                    surfaceTintColor:
                        secondary ?? Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: forgotPasswordHandler,
                  child: Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: secondary ??
                              Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              )
            : Container(),
      ],
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

// lets pause our story about SemanticEntityCard for the moment and learn something about EDS, ednet_design_system library which could help us styling and implementing SemanticEntityCard,  here what we know about EDS, please refactore in accordance with new knowledge:"""
