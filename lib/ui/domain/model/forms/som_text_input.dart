import 'package:flutter/material.dart';
import 'package:som/ui/widgets/design_system/som_input.dart';

class SomTextInput extends StatelessWidget {
  final String? label;
  final String? iconAsset;
  final String? hint;
  final int maxLines; // restored
  final bool showPassword; 
  final bool isPassword;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleShowPassword;
  final TextEditingController? controller;
  final bool required; // restored
  final FormFieldValidator<String>? validator; // restored
  final ValueChanged<String>? onFieldSubmitted;

  const SomTextInput({
    super.key,
    this.label,
    this.iconAsset,
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
    this.validator,
    this.controller,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // If controller is passed, use it. Otherwise create a local one if value is provided? 
    // SomInput requires a controller or handles it internally?
    // The previous implementation created a temporary controller 'controller' from 'value'.
    // We should prioritize the passed 'controller'.
    
    final effectiveController = controller ?? (value != null ? TextEditingController(text: value) : null);
    if (value != null && controller == null && effectiveController != null) {
      // Only update if using the temp controlled value
      if (effectiveController.text != value) {
        effectiveController.text = value!;
        effectiveController.selection = TextSelection.fromPosition(TextPosition(offset: value!.length));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SomInput(
        label: '${label ?? ''}${required ? " *" : ""}',
        hintText: hint,
        isPassword: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        iconAsset: iconAsset,
        maxLines: maxLines,
        controller: effectiveController,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
