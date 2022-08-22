import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String textContent;
  final VoidCallback onPressed;

  // final TextTheme textTheme;

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
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              textContent,
              // style: widget.textTheme ?? Theme.of(context).textTheme.button,
              // ?.copyWith(color: widget.onPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
