import 'package:flutter/material.dart';
import 'package:som/ui/widgets/design_system/som_input.dart';

class SomTextInput extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? hint;
  // Legacy props mapped or ignored
  final bool showPassword; 
  final bool isPassword;
  final int maxLines;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback?
  onToggleShowPassword; // Not needed if SomInput handles internal state, but keeping for API compat if needed
  final bool required;

  // Deprecated/Removed props
  // final Color? onPrimary;
  // final Color? secondary;
  // final void Function()? forgotPasswordHandler;
  // final bool displayForgotPassword;

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
    // Removed deprecated args from constructor to force compile error if used elsewhere
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map legacy SomTextInput to new SomInput
    // Note: SomInput uses an internal controller or controller prop,
    // while SomTextInput uses value+onChanged (controlled vs uncontrolled/prop driven).
    // The new SomInput implemented in prev step uses a controller but also onChanged.
    // We need to bridge the gap.

    // Create a controller to sync value (if provided)
    final controller = value != null ? TextEditingController(text: value) : null;
    if (value != null && controller != null) {
      // optimization: only update text if different to avoid cursor jumps
      controller.selection = TextSelection.fromPosition(TextPosition(offset: value!.length));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SomInput(
        label: label ?? '',
        hintText: hint,
        isPassword: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        // SomInput manages its own visibility toggle state, ignoring showPassword/onToggleShowPassword from parent
        // If we really need external control we'd need to update SomInput
        controller: controller,
      ),
    );
  }
}

// lets pause our story about SemanticEntityCard for the moment and learn something about EDS, ednet_design_system library which could help us styling and implementing SemanticEntityCard,  here what we know about EDS, please refactore in accordance with new knowledge:"""
