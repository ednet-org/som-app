import 'package:flutter/material.dart';

/// Subtle metadata text for IDs, timestamps, and secondary info.
class SomMetaText extends StatelessWidget {
  const SomMetaText(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.outline,
        letterSpacing: 0.2,
        height: 1.3,
      ),
    );
  }
}
