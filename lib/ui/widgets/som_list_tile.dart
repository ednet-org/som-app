import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// ListTile wrapper with consistent padding, hover, and selection animation.
class SomListTile extends StatelessWidget {
  const SomListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.isThreeLine = false,
    this.contentPadding,
    this.dense,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isThreeLine;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.35);
    final hoverColor = theme.colorScheme.surfaceContainerHigh;

    return AnimatedContainer(
      duration: SomDuration.normal,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(SomRadius.sm),
      ),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        selected: selected,
        selectedTileColor: Colors.transparent,
        hoverColor: hoverColor,
        onTap: onTap,
        onLongPress: onLongPress,
        isThreeLine: isThreeLine,
        dense: dense,
        contentPadding: contentPadding ??
            SomDensityTokens.listTilePadding(theme.visualDensity),
      ),
    );
  }
}
