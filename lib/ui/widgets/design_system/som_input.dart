import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';

class SomInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const SomInput({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.icon,
    this.maxLines = 1,
    this.onFieldSubmitted,
  });

  final FormFieldValidator<String>? validator;
  final IconData? icon;
  final int maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<SomInput> createState() => _SomInputState();
}

class _SomInputState extends State<SomInput> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget? suffixIcon;
    if (widget.isPassword) {
      suffixIcon = IconButton(
        icon: SvgPicture.asset(
          _obscureText ? SomAssets.iconVisibilityOn : SomAssets.iconVisibilityOff,
          colorFilter: ColorFilter.mode(
            theme.inputDecorationTheme.suffixIconColor ?? Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        onPressed: _toggleVisibility,
      );
    } else if (widget.controller?.text.isNotEmpty == true) {
       suffixIcon = IconButton(
        icon: SvgPicture.asset(
          SomAssets.iconClearCircle,
          colorFilter: ColorFilter.mode(
            theme.inputDecorationTheme.suffixIconColor ?? Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () => widget.controller?.clear(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using InputDecorator implicitly via TextField
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: theme.textTheme.bodyMedium,
          validator: widget.validator,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            errorText: widget.errorText,
            suffixIcon: suffixIcon,
            icon: widget.icon != null ? Icon(widget.icon, color: theme.colorScheme.primary) : null,
          ),
        ),
      ],
    );
  }
}
