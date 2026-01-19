import 'package:flutter/material.dart';

class ExpandedSplit extends StatelessWidget {
  final Widget? child;

  const ExpandedSplit({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
