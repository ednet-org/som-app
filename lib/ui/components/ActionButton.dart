import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  var textTheme;

  var primary;

  var onPrimary;

  ActionButton(
      {required this.textContent,
      required this.onPressed,
      this.primary,
      this.onPrimary});

  @override
  State<StatefulWidget> createState() {
    return ActionButtonState();
  }
}

class ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(0.0),
        primary: widget.primary ?? Theme.of(context).colorScheme.surface,
        onPrimary: widget.onPrimary ?? Theme.of(context).colorScheme.onSurface,
        // onSurface: Theme.of(context).colorScheme.onSurface,
        // surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        // shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      onPressed: widget.onPressed,
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              widget.textContent,
              style: widget.textTheme ??
                  Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: widget.onPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
