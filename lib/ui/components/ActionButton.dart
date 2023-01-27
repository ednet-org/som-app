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
        backgroundColor: onPrimary,
        foregroundColor: primary,
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
