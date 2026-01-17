import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SomButtonType { primary, secondary, ghost }
enum SomButtonIconPosition { left, right }

class SomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final SomButtonType type;
  final IconData? iconData;
  final String? icon; // restored
  final SomButtonIconPosition iconPosition; // restored
  final bool isLoading; // restored

  const SomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = SomButtonType.primary,
    this.icon,
    this.iconData,
    this.iconPosition = SomButtonIconPosition.left,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final uppercaseText = text.toUpperCase();
    
    Widget label = Text(uppercaseText);
    if (isLoading) {
      label = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else {
      Widget? iconWidget;
      if (icon != null) {
        iconWidget = SvgPicture.asset(
          icon!,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(_getIconColor(context), BlendMode.srcIn),
        );
      } else if (iconData != null) {
        iconWidget = Icon(iconData, size: 20, color: _getIconColor(context));
      }

      if (iconWidget != null) {
        label = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPosition == SomButtonIconPosition.left) ...[
                iconWidget, const SizedBox(width: 8)],
            Text(uppercaseText),
            if (iconPosition == SomButtonIconPosition.right) ...[const SizedBox(width: 8), iconWidget],
          ],
        );
      }
    }

    switch (type) {
      case SomButtonType.primary:
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF818CF8)], // accent-gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: label,
          ),
        );
      case SomButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: label,
        );
      case SomButtonType.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: label,
        );
    }
  }

  Color _getIconColor(BuildContext context) {
    if (type == SomButtonType.primary) return Colors.white;
    return Theme.of(context).colorScheme.primary;
  }
}
