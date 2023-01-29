import 'package:flutter/material.dart';

class ExpandedSplit extends StatelessWidget {
  final child;

  const ExpandedSplit({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: child,
      ),
    );
  }
}
