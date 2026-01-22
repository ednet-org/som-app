import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

class SomInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;

  const SomInput({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.icon,
    this.iconAsset,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.textDirection,
    this.autofillHints,
  });

  final FormFieldValidator<String>? validator;
  final IconData? icon;
  final String? iconAsset;
  final int maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<SomInput> createState() => _SomInputState();
}

class _SomInputState extends State<SomInput> {
  bool _obscureText = true;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant SomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _attachController(widget.controller);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _attachController(TextEditingController? controller) {
    _controller?.removeListener(_handleControllerChange);
    _controller = controller;
    _controller?.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? suffixIcon;
    if (widget.isPassword) {
      suffixIcon = IconButton(
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        icon: SvgPicture.asset(
          _obscureText
              ? SomAssets.iconVisibilityOn
              : SomAssets.iconVisibilityOff,
          colorFilter: ColorFilter.mode(
            theme.inputDecorationTheme.suffixIconColor ?? Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        onPressed: _toggleVisibility,
      );
    } else if (_controller?.text.isNotEmpty == true) {
      suffixIcon = IconButton(
        tooltip: 'Clear',
        icon: SvgPicture.asset(
          SomAssets.iconClearCircle,
          colorFilter: ColorFilter.mode(
            theme.inputDecorationTheme.suffixIconColor ?? Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () => _controller?.clear(),
      );
    }

    final iconColor =
        theme.inputDecorationTheme.prefixIconColor ?? theme.colorScheme.primary;
    Widget? prefixIcon;
    if (widget.iconAsset != null) {
      prefixIcon = Padding(
        padding: const EdgeInsets.all(12),
        child: SomSvgIcon(widget.iconAsset!, size: 20, color: iconColor),
      );
    } else if (widget.icon != null) {
      prefixIcon = Icon(widget.icon, color: iconColor);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using InputDecorator implicitly via TextField
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: theme.textTheme.bodyMedium,
          validator: widget.validator,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onFieldSubmitted: widget.onFieldSubmitted,
          textDirection: widget.textDirection,
          textAlign: TextAlign.left,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            errorText: widget.errorText?.isNotEmpty == true ? ' ' : null,
            errorStyle: const TextStyle(
              height: 0,
              fontSize: 0,
              color: Colors.transparent,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
        if (widget.errorText?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              widget.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
