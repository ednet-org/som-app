import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String textContent;
  final VoidCallback onPressed;

  final Color? primary;

  final Color? onPrimary;

  final double? width;

  const ActionButton({
    Key? key,
    required this.textContent,
    required this.onPressed,
    this.primary,
    this.onPrimary,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(0.0),
        primary: primary ?? Theme.of(context).colorScheme.secondary,
        onPrimary:
            onPrimary ?? Theme.of(context).colorScheme.onSecondaryContainer,
        onSurface: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        shadowColor: Theme.of(context).colorScheme.shadow,
        textStyle: Theme.of(context).textTheme.button,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              textContent,
              style: Theme.of(context).textTheme.button?.copyWith(
                  // backgroundColor: primary,
                  // color: onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
