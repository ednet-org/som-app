import 'package:flutter/material.dart';
import 'package:som/ui/widgets/design_system/som_input.dart';

class SomTextInput extends StatefulWidget {
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
  final String? errorText;
  final Iterable<String>? autofillHints;
  /// Whether to use dense styling for compact layouts.
  final bool isDense;

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
    this.errorText,
    this.autofillHints,
    this.isDense = false,
  });

  @override
  State<SomTextInput> createState() => _SomTextInputState();
}

class _SomTextInputState extends State<SomTextInput> {
  late final TextEditingController _internalController;
  late final FocusNode _focusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant SomTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      final nextValue = widget.value ?? '';
      if (!_focusNode.hasFocus && _internalController.text != nextValue) {
        _internalController.text = nextValue;
        _internalController.selection = TextSelection.fromPosition(
          TextPosition(offset: nextValue.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SomInput(
        label: '${widget.label ?? ''}${widget.required ? " *" : ""}',
        hintText: widget.hint,
        isPassword: widget.isPassword,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        validator: widget.validator,
        iconAsset: widget.iconAsset,
        maxLines: widget.maxLines,
        controller: _effectiveController,
        onFieldSubmitted: widget.onFieldSubmitted,
        errorText: widget.errorText,
        focusNode: _focusNode,
        textDirection: TextDirection.ltr,
        autofillHints: widget.autofillHints,
      ),
    );
  }
}
